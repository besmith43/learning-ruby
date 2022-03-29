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

module Ramaze

  # Easy access to Log

  module Helper::Log
    L = Ramaze::Log

    # The various (default) tags you can use are:
    #
    # :info  - just outputs whatever you give to it without modification.
    # :debug - applies #inspect to everything you pass
    # :error - can take normal strings or exception-objects
    #
    #
    # Usage:
    #
    #   inform :info, 'proceeding as planned'
    #   # [2007-04-04 23:38:39] INFO   proceeding as planned
    #
    #   inform :debug, [1,2,3]
    #   # [2007-04-04 23:38:39] DEBUG  [1, 2, 3]
    #
    #   inform :error, 'something bad happened'
    #   # [2007-04-04 23:38:39] ERROR  something bad happened
    #
    #   inform :error, exception
    #   # [2007-04-04 23:40:59] ERROR  #<RuntimeError: Some exception>
    #   # [2007-04-04 23:40:59] ERROR  hello.rb:23:in `index'
    #   # ... rest of backtrace ...

    def log tag, *args
      L.warn "Helper::Log is being deprecated, use Log directly instead"
      L.send(tag, *args)
    end
    alias inform log
  end
end
