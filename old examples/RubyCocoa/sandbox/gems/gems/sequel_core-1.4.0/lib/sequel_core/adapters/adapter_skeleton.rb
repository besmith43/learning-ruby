#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# require 'adapter_lib'

module Sequel
  module Adapter
    class Database < Sequel::Database
      set_adapter_scheme :adapter
      
      def connect
        AdapterDB.new(@opts[:database], @opts[:user], @opts[:password])
      end
      
      def disconnect
        @pool.disconnect {|c| c.disconnect}
      end
    
      def dataset(opts = nil)
        Adapter::Dataset.new(self, opts)
      end
      
      def execute(sql)
        @logger.info(sql) if @logger
        @pool.hold {|conn| conn.exec(sql)}
      end
      
      alias_method :do, :execute
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

      def fetch_rows(sql, &block)
        @db.synchronize do
          cursor = @db.execute sql
          begin
            @columns = cursor.get_col_names.map {|c| c.to_sym}
            while r = cursor.fetch
              row = {}
              r.each_with_index {|v, i| row[@columns[i]] = v}
              yield row
            end
          ensure
            cursor.close
          end
        end
        self
      end
      
      def insert(*values)
        @db.do insert_sql(*values)
      end
    
      def update(*args, &block)
        @db.do update_sql(*args, &block)
      end
    
      def delete(opts = nil)
        @db.do delete_sql(opts)
      end
    end
  end
end