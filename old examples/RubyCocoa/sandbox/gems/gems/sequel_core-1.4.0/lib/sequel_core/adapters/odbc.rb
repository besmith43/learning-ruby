#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'odbc'

module Sequel
  module ODBC
    class Database < Sequel::Database
      set_adapter_scheme :odbc
    
      # def connect
      #   conn = ::ODBC::connect(@opts[:database], @opts[:user], @opts[:password])
      #   conn.autocommit = true
      #   conn
      # end

      GUARDED_DRV_NAME = /^\{.+\}$/.freeze
      DRV_NAME_GUARDS = '{%s}'.freeze

      def connect
        if @opts.include? :driver
          drv = ::ODBC::Driver.new
          drv.name = 'Sequel ODBC Driver130'
          @opts.each do |param, value|
            if :driver == param and not (value =~ GUARDED_DRV_NAME)
              value = DRV_NAME_GUARDS % value
            end
            drv.attrs[param.to_s.capitalize] = value
          end
          db = ::ODBC::Database.new
          conn = db.drvconnect(drv)
        else
          conn = ::ODBC::connect(@opts[:database], @opts[:user], @opts[:password])
        end
        conn.autocommit = true
        conn
      end      

      def disconnect
        @pool.disconnect {|c| c.disconnect}
      end
    
      def dataset(opts = nil)
        ODBC::Dataset.new(self, opts)
      end
    
      def execute(sql)
        @logger.info(sql) if @logger
        @pool.hold do |conn|
          conn.run(sql)
        end
      end
      
      def do(sql)
        @logger.info(sql) if @logger
        @pool.hold do |conn|
          conn.do(sql)
        end
      end
    end
    
    class Dataset < Sequel::Dataset
      BOOL_TRUE = '1'.freeze
      BOOL_FALSE = '0'.freeze
      
      def literal(v)
        case v
        when true
          BOOL_TRUE
        when false
          BOOL_FALSE
        else
          super
        end
      end

      UNTITLED_COLUMN = 'untitled_%d'.freeze

      def fetch_rows(sql, &block)
        @db.synchronize do
          s = @db.execute sql
          begin
            untitled_count = 0
            @columns = s.columns(true).map do |c|
              if (n = c.name).empty?
                n = UNTITLED_COLUMN % (untitled_count += 1)
              end
              n.to_sym
            end
            rows = s.fetch_all
            rows.each {|row| yield hash_row(row)} if rows
          ensure
            s.drop unless s.nil? rescue nil
          end
        end
        self
      end
    
      # def fetch_rows(sql, &block)
      #   @db.synchronize do
      #     s = @db.execute sql
      #     begin
      #       @columns = s.columns(true).map {|c| c.name.to_sym}
      #       rows = s.fetch_all
      #       rows.each {|row| yield hash_row(row)}
      #     ensure
      #       s.drop unless s.nil? rescue nil
      #     end
      #   end
      #   self
      # end
      
      def hash_row(row)
        hash = {}
        row.each_with_index do |v, idx|
          hash[@columns[idx]] = convert_odbc_value(v)
        end
        hash
      end
      
      def convert_odbc_value(v)
        # When fetching a result set, the Ruby ODBC driver converts all ODBC 
        # SQL types to an equivalent Ruby type; with the exception of
        # SQL_TYPE_DATE, SQL_TYPE_TIME and SQL_TYPE_TIMESTAMP.
        #
        # The conversions below are consistent with the mappings in
        # ODBCColumn#mapSqlTypeToGenericType and Column#klass.
        case v
        when ::ODBC::TimeStamp
          DateTime.new(v.year, v.month, v.day, v.hour, v.minute, v.second)
        when ::ODBC::Time
          DateTime.now
          Time.gm(now.year, now.month, now.day, v.hour, v.minute, v.second)
        when ::ODBC::Date
          Date.new(v.year, v.month, v.day)
        else
          v
        end
      end
      
      def array_tuples_fetch_rows(sql, &block)
        @db.synchronize do
          s = @db.execute sql
          begin
            @columns = s.columns(true).map {|c| c.name.to_sym}
            rows = s.fetch_all
            rows.each {|r| yield array_tuples_make_row(r)}
          ensure
            s.drop unless s.nil? rescue nil
          end
        end
        self
      end
      
      def array_tuples_make_row(row)
        row.keys = @columns
        row.each_with_index do |v, idx|
          # When fetching a result set, the Ruby ODBC driver converts all ODBC 
          # SQL types to an equivalent Ruby type; with the exception of
          # SQL_TYPE_DATE, SQL_TYPE_TIME and SQL_TYPE_TIMESTAMP.
          #
          # The conversions below are consistent with the mappings in
          # ODBCColumn#mapSqlTypeToGenericType and Column#klass.
          case v
          when ::ODBC::TimeStamp
            row[idx] = DateTime.new(v.year, v.month, v.day, v.hour, v.minute, v.second)
          when ::ODBC::Time
            now = DateTime.now
            row[idx] = Time.gm(now.year, now.month, now.day, v.hour, v.minute, v.second)
          when ::ODBC::Date
            row[idx] = Date.new(v.year, v.month, v.day)
          end
        end
        row
      end
      

      def insert(*values)
        @db.do insert_sql(*values)
      end
    
      def update(*args, &block)
        @db.do update_sql(*args, &block)
        self
      end
    
      def delete(opts = nil)
        @db.do delete_sql(opts)
      end
    end
  end
end