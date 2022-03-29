#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Sequel
  class Model
    HOOKS = [
      :after_initialize,
      :before_create,
      :after_create,
      :before_update,
      :after_update,
      :before_save,
      :after_save,
      :before_destroy,
      :after_destroy
    ]
    
    # Some fancy code generation here in order to define the hook class methods...
    HOOK_METHOD_STR = %Q{
      def self.%s(method = nil, &block)
        unless block
          (raise SequelError, 'No hook method specified') unless method
          block = proc {send method}
        end
        add_hook(%s, &block)
      end
    }
    
    def self.def_hook_method(m) #:nodoc:
      instance_eval(HOOK_METHOD_STR % [m.to_s, m.inspect])
    end
    
    HOOKS.each {|h| define_method(h) {}}
    HOOKS.each {|h| def_hook_method(h)}
    
    # Returns the hooks hash for the model class.
    def self.hooks #:nodoc:
      @hooks ||= Hash.new {|h, k| h[k] = []}
    end
    
    def self.add_hook(hook, &block) #:nodoc:
      chain = hooks[hook]
      chain << block
      define_method(hook) do 
        return false if super == false
        chain.each {|h| break false if instance_eval(&h) == false}
      end
    end

    # Returns true if the model class or any of its ancestors have defined
    # hooks for the given hook key. Notice that this method cannot detect 
    # hooks defined using overridden methods.
    def self.has_hooks?(key)
      has = hooks[key] && !hooks[key].empty?
      has || ((self != Model) && superclass.has_hooks?(key))
    end
  end
end