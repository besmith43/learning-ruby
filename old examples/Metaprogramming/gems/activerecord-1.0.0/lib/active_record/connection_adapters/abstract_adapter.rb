#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'benchmark'
require 'date'

module ActiveRecord
  class Base
    class ConnectionSpecification #:nodoc:
      attr_reader :config, :adapter_method
      def initialize (config, adapter_method)
        @config, @adapter_method = config, adapter_method
      end
    end

    # The class -> [adapter_method, config] map
    @@defined_connections = {}

    # Establishes the connection to the database. Accepts a hash as input where
    # the :adapter key must be specified with the name of a database adapter (in lower-case)
    # example for regular databases (MySQL, Postgresql, etc):
    #
    #   ActiveRecord::Base.establish_connection(
    #     :adapter  => "mysql",
    #     :host     => "localhost",
    #     :username => "myuser",
    #     :password => "mypass",
    #     :database => "somedatabase"
    #   )
    #
    # Example for SQLite database:
    #
    #   ActiveRecord::Base.establish_connection(
    #     :adapter => "sqlite",
    #     :dbfile  => "path/to/dbfile"
    #   )
    #
    # Also accepts keys as strings (for parsing from yaml for example):
    #   ActiveRecord::Base.establish_connection(
    #     "adapter" => "sqlite",
    #     "dbfile"  => "path/to/dbfile"
    #   )
    #
    # The exceptions AdapterNotSpecified, AdapterNotFound and ArgumentError
    # may be returned on an error.
    #
    # == Connecting to another database for a single model
    #
    # To support different connections for different classes, you can
    # simply call establish_connection with the classes you wish to have
    # different connections for:
    #
    #   class Courses < ActiveRecord::Base
    #    ...
    #   end
    #
    #   Courses.establish_connection( ... )
    def self.establish_connection(spec)
      if spec.instance_of? ConnectionSpecification
        @@defined_connections[self] = spec
      else
        if spec.nil? then raise AdapterNotSpecified end
        symbolize_strings_in_hash(spec)
        unless spec.key?(:adapter) then raise AdapterNotSpecified end
    
        adapter_method = "#{spec[:adapter]}_connection"
        unless methods.include?(adapter_method) then raise AdapterNotFound end
        remove_connection
        @@defined_connections[self] = ConnectionSpecification.new(spec, adapter_method)
      end
    end
    
    # Locate the connection of the nearest super class. This can be an
    # active or defined connections: if it is the latter, it will be
    # opened and set as the active connection for the class it was defined
    # for (not necessarily the current class).
    def self.retrieve_connection #:nodoc:
      klass = self
      until klass == ActiveRecord::Base.superclass
        Thread.current['active_connections'] ||= {}
        if Thread.current['active_connections'][klass]
          return Thread.current['active_connections'][klass]
        elsif @@defined_connections[klass]
          klass.connection = @@defined_connections[klass]
          return self.connection
        end
        klass = klass.superclass
      end
      raise ConnectionNotEstablished
    end
    
    # Returns true if a connection that's accessible to this class have already been opened.
    def self.connected?
      klass = self
      until klass == ActiveRecord::Base.superclass
        if Thread.current['active_connections'].is_a?(Hash) && Thread.current['active_connections'][klass]
          return true 
        else
          klass = klass.superclass
        end
      end
      return false
    end
    
    # Remove the connection for this class. This will close the active
    # connection and the defined connection (if they exist). The result
    # can be used as argument for establish_connection, for easy
    # re-establishing of the connection.
    def self.remove_connection(klass=self)
      conn = @@defined_connections[klass]
      @@defined_connections.delete(klass)
      Thread.current['active_connections'] ||= {}
      Thread.current['active_connections'][klass] = nil
      conn.config if conn
    end
    
    # Set the connection for the class.
    def self.connection=(spec)
      raise ConnectionNotEstablished unless spec
      conn = self.send(spec.adapter_method, spec.config)
      Thread.current['active_connections'] ||= {}
      Thread.current['active_connections'][self] = conn
    end

    # Converts all strings in a hash to symbols.
    def self.symbolize_strings_in_hash(hash)
      hash.each do |key, value|
        if key.class == String
          hash.delete key
          hash[key.intern] = value
        end
      end
    end
  end

  module ConnectionAdapters # :nodoc:
    class Column # :nodoc:
      attr_reader :name, :default, :type, :limit
      # The name should contain the name of the column, such as "name" in "name varchar(250)"
      # The default should contain the type-casted default of the column, such as 1 in "count int(11) DEFAULT 1"
      # The type parameter should either contain :integer, :float, :datetime, :date, :text, or :string
      # The sql_type is just used for extracting the limit, such as 10 in "varchar(10)"
      def initialize(name, default, sql_type = nil)
        @name, @default, @type = name, default, simplified_type(sql_type)
        @limit = extract_limit(sql_type) unless sql_type.nil?
      end

      def default
        type_cast(@default)
      end

      def klass
        case type
          when :integer       then Fixnum
          when :float         then Float
          when :datetime      then Time
          when :date          then Date
          when :text, :string then String
          when :boolean       then Object
        end
      end
      
      def type_cast(value)
        if value.nil? then return nil end
        case type
          when :string   then value
          when :text     then value
          when :integer  then value.to_i
          when :float    then value.to_f
          when :datetime then string_to_time(value)
          when :date     then string_to_date(value)
          when :boolean  then (value == "t" or value == true ? true : false)
          else value
        end
      end
      
      def human_name
        Base.human_attribute_name(@name)
      end

      private
        def string_to_date(string)
          return string if Date === string
          date_array = ParseDate.parsedate(string)
          # treat 0000-00-00 as nil
          Date.new(date_array[0], date_array[1], date_array[2]) rescue nil
        end
        
        def string_to_time(string)
          return string if Time === string
          time_array = ParseDate.parsedate(string).compact
          # treat 0000-00-00 00:00:00 as nil
          Time.local(*time_array) rescue nil
        end

        def extract_limit(sql_type)
          $1.to_i if sql_type =~ /\((.*)\)/
        end

        def simplified_type(field_type)
          case field_type
            when /int/i
              :integer
            when /float|double|decimal|numeric/i
              :float
            when /time/i
              :datetime
            when /date/i
              :date
            when /(c|b)lob/i, /text/i
              :text
            when /char/i, /string/i
              :string
            when /boolean/i
              :boolean
          end
        end
    end

    # All the concrete database adapters follow the interface laid down in this class.
    # You can use this interface directly by borrowing the database connection from the Base with
    # Base.connection.
    class AbstractAdapter
      @@row_even = true

      include Benchmark

      def initialize(connection, logger = nil) # :nodoc:
        @connection, @logger = connection, logger
        @runtime = 0
      end

      # Returns an array of record hashes with the column names as a keys and fields as values.
      def select_all(sql, name = nil) end
      
      # Returns a record hash with the column names as a keys and fields as values.
      def select_one(sql, name = nil) end

      # Returns an array of column objects for the table specified by +table_name+.
      def columns(table_name, name = nil) end

      # Returns the last auto-generated ID from the affected table.
      def insert(sql, name = nil, pk = nil, id_value = nil) end

      # Executes the update statement.
      def update(sql, name = nil) end

      # Executes the delete statement.
      def delete(sql, name = nil) end

      def reset_runtime # :nodoc:
        rt = @runtime
        @runtime = 0
        return rt
      end

      # Begins the transaction (and turns off auto-committing).
      def begin_db_transaction()    end
      
      # Commits the transaction (and turns on auto-committing). 
      def commit_db_transaction()   end

      # Rollsback the transaction (and turns on auto-committing). Must be done if the transaction block
      # raises an exception or returns false.
      def rollback_db_transaction() end

      def quote(value, column = nil)
        case value
          when String                      then "'#{value.gsub(/\\/,'\&\&').gsub(/'/, "''")}'" # ' (for ruby-mode)
          when NilClass                    then "NULL"
          when TrueClass                   then (column && column.type == :boolean ? "'t'" : "1")
          when FalseClass                  then (column && column.type == :boolean ? "'f'" : "0")
          when Float, Fixnum, Bignum, Date then "'#{value.to_s}'" 
          when Time, DateTime              then "'#{value.strftime("%Y-%m-%d %H:%M:%S")}'"
          else                                  "'#{value.to_yaml.gsub(/'/, "''")}'"
        end
      end

      def quote_column_name(name)
        return name
      end

      # Returns a string of the CREATE TABLE SQL statements for recreating the entire structure of the database.
      def structure_dump() end

      protected
        def log(sql, name, connection, &action)
          begin
            if @logger.nil?
              action.call(connection)
            else
              result = nil
              bm = measure { result = action.call(connection) }
              @runtime += bm.real
              log_info(sql, name, bm.real)
              result
            end
          rescue => e
            log_info("#{e.message}: #{sql}", name, 0)
            raise ActiveRecord::StatementInvalid, "#{e.message}: #{sql}"
          end
        end

        def log_info(sql, name, runtime)
          if @logger.nil? then return end

          @logger.info(
            format_log_entry(
              "#{name.nil? ? "SQL" : name} (#{sprintf("%f", runtime)})", 
              sql.gsub(/ +/, " ")
            )
          )
        end

        def format_log_entry(message, dump = nil)
          if @@row_even then
            @@row_even = false; caller_color = "1;32"; message_color = "4;33"; dump_color = "1;37"
          else
            @@row_even = true; caller_color = "1;36"; message_color = "4;35"; dump_color = "0;37"
          end
          
          log_entry = "  \e[#{message_color}m#{message}\e[m"
          log_entry << "   \e[#{dump_color}m%s\e[m" % dump if dump.kind_of?(String) && !dump.nil?
          log_entry << "   \e[#{dump_color}m%p\e[m" % dump if !dump.kind_of?(String) && !dump.nil?
          log_entry
        end
    end
  end
end
