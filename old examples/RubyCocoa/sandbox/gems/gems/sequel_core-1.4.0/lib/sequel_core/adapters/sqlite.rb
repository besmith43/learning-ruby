#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'sqlite3'

module Sequel
  module SQLite
    class Database < Sequel::Database
      set_adapter_scheme :sqlite
    
      def serial_primary_key_options
        {:primary_key => true, :type => :integer, :auto_increment => true}
      end

      def connect
        if @opts[:database].nil? || @opts[:database].empty?
          @opts[:database] = ':memory:'
        end
        db = ::SQLite3::Database.new(@opts[:database])
        db.type_translation = true
        # fix for timestamp translation
        db.translator.add_translator("timestamp") do |t, v|
          v =~ /^\d+$/ ? Time.at(v.to_i) : Time.parse(v) 
        end 
        db
      end
      
      def disconnect
        @pool.disconnect {|c| c.close}
      end
    
      def dataset(opts = nil)
        SQLite::Dataset.new(self, opts)
      end
      
      TABLES_FILTER = "type = 'table' AND NOT name = 'sqlite_sequence'"
    
      def tables
        self[:sqlite_master].filter(TABLES_FILTER).map {|r| r[:name].to_sym}
      end
    
      def execute(sql)
        @logger.info(sql) if @logger
        @pool.hold {|conn| conn.execute_batch(sql); conn.changes}
      rescue RuntimeError => e
        raise Error::InvalidStatement, "#{sql}\r\n#{e.message}"
      end
      
      def execute_insert(sql)
        @logger.info(sql) if @logger
        @pool.hold {|conn| conn.execute(sql); conn.last_insert_row_id}
      rescue RuntimeError => e
        raise Error::InvalidStatement, "#{sql}\r\n#{e.message}"
      end
      
      def single_value(sql)
        @logger.info(sql) if @logger
        @pool.hold {|conn| conn.get_first_value(sql)}
      rescue RuntimeError => e
        raise Error::InvalidStatement, "#{sql}\r\n#{e.message}"
      end
      
      def execute_select(sql, &block)
        @logger.info(sql) if @logger
        @pool.hold {|conn| conn.query(sql, &block)}
      rescue RuntimeError => e
        raise Error::InvalidStatement, "#{sql}\r\n#{e.message}"
      end
      
      def pragma_get(name)
        single_value("PRAGMA #{name}")
      end
      
      def pragma_set(name, value)
        execute("PRAGMA #{name} = #{value}")
      end
      
      AUTO_VACUUM = {'0' => :none, '1' => :full, '2' => :incremental}.freeze
      
      def auto_vacuum
        AUTO_VACUUM[pragma_get(:auto_vacuum)]
      end
      
      def auto_vacuum=(value)
        value = AUTO_VACUUM.index(value) || (raise Error, "Invalid value for auto_vacuum option. Please specify one of :none, :full, :incremental.")
        pragma_set(:auto_vacuum, value)
      end
      
      SYNCHRONOUS = {'0' => :off, '1' => :normal, '2' => :full}.freeze
      
      def synchronous
        SYNCHRONOUS[pragma_get(:synchronous)]
      end
      
      def synchronous=(value)
        value = SYNCHRONOUS.index(value) || (raise Error, "Invalid value for synchronous option. Please specify one of :off, :normal, :full.")
        pragma_set(:synchronous, value)
      end
      
      TEMP_STORE = {'0' => :default, '1' => :file, '2' => :memory}.freeze
      
      def temp_store
        TEMP_STORE[pragma_get(:temp_store)]
      end
      
      def temp_store=(value)
        value = TEMP_STORE.index(value) || (raise Error, "Invalid value for temp_store option. Please specify one of :default, :file, :memory.")
        pragma_set(:temp_store, value)
      end
      
      def alter_table_sql(table, op)
        case op[:op]
        when :add_column
          "ALTER TABLE #{table} ADD #{column_definition_sql(op)}"
        else
          raise Error, "Unsupported ALTER TABLE operation"
        end
      end
      
      def transaction(&block)
        @pool.hold do |conn|
          if conn.transaction_active?
            return yield(conn)
          end
          begin
            result = nil
            conn.transaction {result = yield(conn)}
            result
          rescue => e
            raise e unless Error::Rollback === e
          end
        end
      end
    end
    
    class Dataset < Sequel::Dataset
      def literal(v)
        case v
        when Time
          literal(v.iso8601)
        else
          super
        end
      end

      def insert_sql(*values)
        if (values.size == 1) && values.first.is_a?(Sequel::Dataset)
          "INSERT INTO #{@opts[:from]} #{values.first.sql};"
        else
          super(*values)
        end
      end

      def fetch_rows(sql, &block)
        @db.execute_select(sql) do |result|
          @columns = result.columns.map {|c| c.to_sym}
          column_count = @columns.size
          result.each do |values|
            row = {}
            column_count.times {|i| row[@columns[i]] = values[i]}
            block.call(row)
          end
        end
      end
      
      def array_tuples_fetch_rows(sql, &block)
        @db.execute_select(sql) do |result|
          @columns = result.columns.map {|c| c.to_sym}
          result.each {|r| r.keys = @columns; block[r]}
        end
      end
    
      def insert(*values)
        @db.execute_insert insert_sql(*values)
      end
    
      def update(*args, &block)
        @db.execute update_sql(*args, &block)
      end
    
      def delete(opts = nil)
        # check if no filter is specified
        unless (opts && opts[:where]) || @opts[:where]
          @db.transaction do
            unfiltered_count = count
            @db.execute delete_sql(opts)
            unfiltered_count
          end
        else
          @db.execute delete_sql(opts)
        end
      end
      
      EXPLAIN = 'EXPLAIN %s'.freeze

      def explain
        res = []
        @db.result_set(EXPLAIN % select_sql(opts), nil) {|r| res << r}
        res
      end
    end
  end
end
