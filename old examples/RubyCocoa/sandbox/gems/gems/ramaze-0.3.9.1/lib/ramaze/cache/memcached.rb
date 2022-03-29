#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.
require 'memcache'

module Ramaze

  # Cache based on the memcache library which utilizes the memcache-daemon to
  # store key/value pairs in namespaces.

  class MemcachedCache

    # Create a new MemcachedCache with host, port and a namespace that defaults
    # to 'ramaze'
    #
    # For your own usage you should use another namespace.

    def initialize(host = 'localhost', port = '11211', namespace = SEEED)
      namespace = Digest::SHA1.hexdigest(namespace)[0..16]
      @cache = MemCache.new("#{host}:#{port}", :namespace => namespace, :multithread => true)
    end

    # please read the documentation of memcache-client for further methods.
    # also, it is highly recommended to install memcache-client_extensions
    # for a bit of speedup and more functionality
    # Some examples:
    #
    # [key]                       #=> get a key
    # [key] = value               #=> set a key
    # delete(key)                 #=> delete key
    # set_many :x => :y, :n => :m #=> set many key/value pairs
    # get_hash :x, :y             #=> return a hash with key/value pairs
    # stats                       #=> get some statistics about usage
    # namespace                   #=> get the current namespace
    # namespace = 'ramaze'        #=> set a different namespace ('ramaze' is default)
    # flush_all                   #=> flush the whole cache (deleting all)
    # compression                 #=> see if compression is true/false
    # compression = false         #=> turn off compression (it's by default true)

    def method_missing(*args, &block)
      @cache.__send__(*args, &block)
    rescue MemCache::MemCacheError => e
      Log.error e.to_s
      nil
    end

    # out of some reason MemCache sometimes doesn't respond to
    # get_multi, have to investigate this further.
    #
    # for now, i'll just use the dumbed down version and ask it
    # whether it implements this functionality or not.

    def get_multi(*keys)
      if @cache.respond_to?(:get_multi)
        @cache.get_multi(*keys)
      else
        @cache.get_hash(*keys)
      end
    end

    # same as get_multi, but returns only the values (in order)

    def values_at(*keys)
      get_multi(*keys).values_at(*keys)
    end

    def clear
      @cache.flush_all
    end
  end
end
