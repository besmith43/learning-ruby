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
    def self.set_cache(store, opts = {})
      @cache_store = store
      if (ttl = opts[:ttl])
        set_cache_ttl(ttl)
      end
      
      meta_def(:[]) do |*args|
        if (args.size == 1) && (Hash === (h = args.first))
          return dataset[h]
        end
        
        unless obj = @cache_store.get(cache_key_from_values(args))
          obj = dataset[primary_key_hash((args.size == 1) ? args.first : args)]
          @cache_store.set(cache_key_from_values(args), obj, cache_ttl)
        end
        obj
      end
      
      class_def(:set) {|v| store.delete(cache_key); super}
      class_def(:save) {store.delete(cache_key); super}
      class_def(:delete) {store.delete(cache_key); super}
    end
    
    def self.set_cache_ttl(ttl)
      @cache_ttl = ttl
    end
    
    def self.cache_store
      @cache_store
    end
    
    def self.cache_ttl
      @cache_ttl ||= 3600
    end
    
    def self.cache_key_from_values(values)
      "#{self}:#{values.join(',')}"
    end
  end
end