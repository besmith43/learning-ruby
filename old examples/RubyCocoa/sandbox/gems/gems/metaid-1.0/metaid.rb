#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Metaid == a few simple metaclass helper
# (See http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html.)
class Object
    # The hidden singleton lurks behind everyone
    def metaclass; class << self; self; end; end
    def meta_eval &blk; metaclass.instance_eval &blk; end

    # Adds methods to a metaclass
    def meta_def name, &blk
        meta_eval { define_method name, &blk }
    end

    # Defines an instance method within a class
    def class_def name, &blk
        class_eval { define_method name, &blk }
    end
end
