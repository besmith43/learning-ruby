#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
module ActiveRecord
  module Reflection # :nodoc:
    def self.append_features(base)
      super
      base.extend(ClassMethods)

      base.class_eval do
        class << self
          alias_method :composed_of_without_reflection, :composed_of

          def composed_of_with_reflection(part_id, options = {})
            composed_of_without_reflection(part_id, options)
            write_inheritable_array "aggregations", [ AggregateReflection.new(part_id, options, self) ]
          end

          alias_method :composed_of, :composed_of_with_reflection          
        end
      end
      
      for association_type in %w( belongs_to has_one has_many has_and_belongs_to_many )
        base.module_eval <<-"end_eval"
          class << self
            alias_method :#{association_type}_without_reflection, :#{association_type}

            def #{association_type}_with_reflection(association_id, options = {})
              #{association_type}_without_reflection(association_id, options)
              write_inheritable_array "associations", [ AssociationReflection.new(association_id, options, self) ]
            end

            alias_method :#{association_type}, :#{association_type}_with_reflection          
          end
        end_eval
      end
    end

    # Reflection allows you to interrogate Active Record classes and objects about their associations and aggregations. 
    # This information can for example be used in a form builder that took an Active Record object and created input
    # fields for all of the attributes depending on their type and displayed the associations to other objects.
    #
    # You can find the interface for the AggregateReflection and AssociationReflection classes in the abstract MacroReflection class.
    module ClassMethods
      # Returns an array of AggregateReflection objects for all the aggregations in the class.
      def reflect_on_all_aggregations
        read_inheritable_attribute "aggregations"
      end
      
      # Returns the AggregateReflection object for the named +aggregation+ (use the symbol). Example:
      #   Account.reflect_on_aggregation(:balance) # returns the balance AggregateReflection
      def reflect_on_aggregation(aggregation)
        reflect_on_all_aggregations.find { |reflection| reflection.name == aggregation } unless reflect_on_all_aggregations.nil?
      end

      # Returns an array of AssociationReflection objects for all the aggregations in the class.
      def reflect_on_all_associations
        read_inheritable_attribute "associations"
      end
      
      # Returns the AssociationReflection object for the named +aggregation+ (use the symbol). Example:
      #   Account.reflect_on_association(:owner) # returns the owner AssociationReflection
      def reflect_on_association(association)
        reflect_on_all_associations.find { |reflection| reflection.name == association } unless reflect_on_all_associations.nil?
      end
    end
    

    # Abstract base class for AggregateReflection and AssociationReflection that describes the interface available for both of 
    # those classes. Objects of AggregateReflection and AssociationReflection are returned by the Reflection::ClassMethods.
    class MacroReflection
      attr_reader :active_record
      def initialize(name, options, active_record)
        @name, @options, @active_record = name, options, active_record
      end
      
      # Returns the name of the macro, so it would return :balance for "composed_of :balance, :class_name => 'Money'" or
      # :clients for "has_many :clients".
      def name
        @name
      end
      
      # Returns the hash of options used for the macro, so it would return { :class_name => "Money" } for 
      # "composed_of :balance, :class_name => 'Money'" or {} for "has_many :clients".
      def options
        @options
      end
      
      # Returns the class for the macro, so "composed_of :balance, :class_name => 'Money'" would return the Money class and
      # "has_many :clients" would return the Client class.
      def klass() end
      
      def ==(other_aggregation)
        name == other_aggregation.name && other_aggregation.options && active_record == other_aggregation.active_record
      end
    end


    # Holds all the meta-data about an aggregation as it was specified in the Active Record class.
    class AggregateReflection < MacroReflection #:nodoc:
      def klass
        Object.const_get(options[:class_name] || name_to_class_name(name.id2name)) 
      end
      
      private
        def name_to_class_name(name)
          name.capitalize.gsub(/_(.)/) { |s| $1.capitalize }
        end
    end

    # Holds all the meta-data about an association as it was specified in the Active Record class.
    class AssociationReflection < MacroReflection #:nodoc:
      def klass
        active_record.send(:compute_type, (name_to_class_name(name.id2name)))
      end

      private
        def name_to_class_name(name)
          if name !~ /::/
            class_name = active_record.send(
              :type_name_with_module, 
              (options[:class_name] || active_record.class_name(active_record.table_name_prefix + name + active_record.table_name_suffix))
            )
          end
          return class_name || name
        end
    end
  end
end