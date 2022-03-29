#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Sequel
  module Schema
    module SQL
      RESTRICT = 'RESTRICT'.freeze
      CASCADE = 'CASCADE'.freeze
      NO_ACTION = 'NO ACTION'.freeze
      SET_NULL = 'SET NULL'.freeze
      SET_DEFAULT = 'SET DEFAULT'.freeze
    
      def on_delete_clause(action)
        case action
        when :restrict
          RESTRICT
        when :cascade
          CASCADE
        when :set_null
          SET_NULL
        when :set_default
          SET_DEFAULT
        else
          NO_ACTION
        end
      end
      
      AUTOINCREMENT = 'AUTOINCREMENT'.freeze

      def auto_increment_sql
        AUTOINCREMENT
      end
      
      COMMA_SEPARATOR = ', '.freeze
      UNIQUE = ' UNIQUE'.freeze
      NOT_NULL = ' NOT NULL'.freeze
      NULL = ' NULL'.freeze
      UNSIGNED = ' UNSIGNED'.freeze
      PRIMARY_KEY = ' PRIMARY KEY'.freeze

      TYPES = Hash.new {|h, k| k}
      TYPES[:double] = 'double precision'
      
      def schema_utility_dataset
        @schema_utility_dataset ||= dataset
      end
      
      def literal(v)
        schema_utility_dataset.literal(v)
      end
      
      def type_literal(t)
        t.is_a?(Symbol) ? t.to_s : literal(t)
      end
      
      def expression_list(*args, &block)
        schema_utility_dataset.expression_list(*args, &block)
      end

      def column_definition_sql(column)
        if column[:type] == :check
          return constraint_definition_sql(column)
        end
        sql = "#{literal(column[:name].to_sym)} #{type_literal(TYPES[column[:type]])}"
        column[:size] ||= 255 if column[:type] == :varchar
        elements = column[:size] || column[:elements]
        sql << "(#{literal(elements)})" if elements
        sql << UNSIGNED if column[:unsigned]
        sql << UNIQUE if column[:unique]
        sql << NOT_NULL if column[:null] == false
        sql << NULL if column[:null] == true
        sql << " DEFAULT #{literal(column[:default])}" if column.include?(:default)
        sql << PRIMARY_KEY if column[:primary_key]
        sql << " #{auto_increment_sql}" if column[:auto_increment]
        if column[:table]
          sql << " REFERENCES #{column[:table]}"
          sql << "(#{column[:key]})" if column[:key]
          sql << " ON DELETE #{on_delete_clause(column[:on_delete])}" if column[:on_delete]
        end
        sql
      end
      
      def constraint_definition_sql(column)
        sql = column[:name] ? "CONSTRAINT #{literal(column[:name].to_sym)} " : ""
        
        sql << "CHECK #{expression_list(column[:check], true)}"
        sql
      end
  
      def column_list_sql(columns)
        columns.map {|c| column_definition_sql(c)}.join(COMMA_SEPARATOR)
      end
    
      UNDERSCORE = '_'.freeze

      def default_index_name(table_name, columns)
        "#{table_name}_#{columns.join(UNDERSCORE)}_index"
      end
    
      def index_definition_sql(table_name, index)
        index_name = index[:name] || default_index_name(table_name, index[:columns])
        if index[:full_text]
          raise Error, "Full-text indexes are not supported for this database"
        elsif index[:unique]
          "CREATE UNIQUE INDEX #{index_name} ON #{table_name} (#{literal(index[:columns])})"
        else
          "CREATE INDEX #{index_name} ON #{table_name} (#{literal(index[:columns])})"
        end
      end
    
      def index_list_sql_list(table_name, indexes)
        indexes.map {|i| index_definition_sql(table_name, i)}
      end
  
      def create_table_sql_list(name, columns, indexes = nil)
        sql = ["CREATE TABLE #{name} (#{column_list_sql(columns)})"]
        if indexes && !indexes.empty?
          sql.concat(index_list_sql_list(name, indexes))
        end
        sql
      end
      
      def drop_table_sql(name)
        "DROP TABLE #{name}"
      end
      
      def rename_table_sql(name, new_name)
        "ALTER TABLE #{name} RENAME TO #{new_name}"
      end
      
      def alter_table_sql_list(table, operations)
        operations.map {|op| alter_table_sql(table, op)}
      end
      
      def alter_table_sql(table, op)
        case op[:op]
        when :add_column
          "ALTER TABLE #{table} ADD COLUMN #{column_definition_sql(op)}"
        when :drop_column
          "ALTER TABLE #{table} DROP COLUMN #{literal(op[:name])}"
        when :rename_column
          "ALTER TABLE #{table} RENAME COLUMN #{literal(op[:name])} TO #{literal(op[:new_name])}"
        when :set_column_type
          "ALTER TABLE #{table} ALTER COLUMN #{literal(op[:name])} TYPE #{op[:type]}"
        when :set_column_default
          "ALTER TABLE #{table} ALTER COLUMN #{literal(op[:name])} SET DEFAULT #{literal(op[:default])}"
        when :add_index
          index_definition_sql(table, op)
        when :drop_index
          "DROP INDEX #{default_index_name(table, op[:columns])}"
        when :add_constraint
          "ALTER TABLE #{table} ADD #{constraint_definition_sql(op)}"
        when :drop_constraint
          "ALTER TABLE #{table} DROP CONSTRAINT #{literal(op[:name])}"
        else
          raise Error, "Unsupported ALTER TABLE operation"
        end
      end
    end
  end
end

