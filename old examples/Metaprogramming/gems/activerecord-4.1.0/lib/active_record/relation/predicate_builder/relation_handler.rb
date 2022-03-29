#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
module ActiveRecord
  class PredicateBuilder
    class RelationHandler # :nodoc:
      def call(attribute, value)
        if value.select_values.empty?
          value = value.select(value.klass.arel_table[value.klass.primary_key])
        end

        attribute.in(value.arel.ast)
      end
    end
  end
end
