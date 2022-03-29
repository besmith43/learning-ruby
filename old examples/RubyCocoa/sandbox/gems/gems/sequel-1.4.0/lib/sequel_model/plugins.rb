#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Sequel
  module Plugins; end
  
  class Model
    class << self
      # Loads a plugin for use with the model class, passing optional arguments
      # to the plugin.
      def is(plugin, *args)
        m = plugin_module(plugin)
        if m.respond_to?(:apply)
          m.apply(self, *args)
        end
        if m.const_defined?("InstanceMethods")
          class_def(:"#{plugin}_opts") {args.first}
          include(m::InstanceMethods)
        end
        if m.const_defined?("ClassMethods")
          meta_def(:"#{plugin}_opts") {args.first}
          metaclass.send(:include, m::ClassMethods)
        end
        if m.const_defined?("DatasetMethods")
          unless @dataset
            raise Sequel::Error, "Plugin cannot be applied because the model class has no dataset"
          end
          dataset.meta_def(:"#{plugin}_opts") {args.first}
          dataset.metaclass.send(:include, m::DatasetMethods)
        end
      end
      alias_method :is_a, :is
    
      # Returns the module for the specified plugin. If the module is not 
      # defined, the corresponding plugin gem is automatically loaded.
      def plugin_module(plugin)
        module_name = plugin.to_s.gsub(/(^|_)(.)/) {$2.upcase}
        if not Sequel::Plugins.const_defined?(module_name)
          require plugin_gem(plugin)
        end
        Sequel::Plugins.const_get(module_name)
      end

      # Returns the gem name for the given plugin.
      def plugin_gem(plugin)
        "sequel_#{plugin}"
      end
    end
  end
end