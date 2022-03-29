#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'active_record/connection_adapters/abstract_adapter'
require 'parsedate'

begin
  begin
    # Only include the MySQL driver if one hasn't already been loaded
    require 'mysql' unless self.class.const_defined?(:Mysql)
  rescue LoadError
    # Only use the supplied backup Ruby/MySQL driver if no driver is already in place
    require 'active_record/vendor/mysql'
  end

module ActiveRecord
  class Base
    # Establishes a connection to the database that's used by all Active Record objects
    def self.mysql_connection(config) # :nodoc:
      symbolize_strings_in_hash(config)
      host     = config[:host]
      port     = config[:port]
      socket   = config[:socket]
      username = config[:username] || "root"
      password = config[:password]

      if config.has_key?(:database)
        database = config[:database]
      else
        raise ArgumentError, "No database specified. Missing argument: database."
      end

      ConnectionAdapters::MysqlAdapter.new(
        Mysql::real_connect(host, username, password, database, port, socket), logger
      )
    end
  end

  module ConnectionAdapters
    class MysqlAdapter < AbstractAdapter # :nodoc:
      def select_all(sql, name = nil)
        select(sql, name)
      end

      def select_one(sql, name = nil)
        result = select(sql, name)
        result.nil? ? nil : result.first
      end

      def columns(table_name, name = nil)
        sql = "SHOW FIELDS FROM #{table_name}"
        result = nil
        log(sql, name, @connection) { |connection| result = connection.query(sql) }

        columns = []
        result.each { |field| columns << Column.new(field[0], field[4], field[1]) }
        columns
      end

      def insert(sql, name = nil, pk = nil, id_value = nil)
        execute(sql, name = nil)
        return id_value || @connection.insert_id
      end

      def execute(sql, name = nil)
        log(sql, name, @connection) { |connection| connection.query(sql) }
      end

      alias_method :update, :execute
      alias_method :delete, :execute
      
      def begin_db_transaction
        begin
          execute "BEGIN"
        rescue Exception
          # Transactions aren't supported
        end
      end
      
      def commit_db_transaction
        begin
          execute "COMMIT"
        rescue Exception
          # Transactions aren't supported
        end
      end
      
      def rollback_db_transaction
        begin
          execute "ROLLBACK"
        rescue Exception
          # Transactions aren't supported
        end
      end

      def quote_column_name(name)
        return "`#{name}`"
      end
      
      def structure_dump
        select_all("SHOW TABLES").inject("") do |structure, table|
          structure += select_one("SHOW CREATE TABLE #{table.to_a.first.last}")["Create Table"] + ";\n\n"
        end
      end
      
      def recreate_database(name)
        drop_database(name)
        create_database(name)
      end
      
      def drop_database(name)
        execute "DROP DATABASE IF EXISTS #{name}"
      end
      
      def create_database(name)
        execute "CREATE DATABASE #{name}"
      end
      
      private
        def select(sql, name = nil)
          result = nil
          log(sql, name, @connection) { |connection| connection.query_with_result = true; result = connection.query(sql) }
          rows = []
          all_fields_initialized = result.fetch_fields.inject({}) { |all_fields, f| all_fields[f.name] = nil; all_fields }
          result.each_hash { |row| rows << all_fields_initialized.dup.update(row) }
          rows
        end
    end
  end
end

rescue LoadError
  # MySQL is not available, so neither should the adapter be
end
