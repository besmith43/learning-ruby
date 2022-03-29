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

require 'syslog'

module Ramaze

  # Informer for Syslog from rubys standard-library.

  class Syslog
    include ::Syslog

    # opens syslog

    def initialize
      open unless ::Syslog.opened?
    end

    # alias for default syslog methods so they match ramaze
    alias error err
    alias warn warning
    alias dev debug

    # just sends all messages received to ::Syslog
    def inform(tag, *args)
      self.__send__(tag, *args)
    end

    public :error, :warn

    # Has to call the modules singleton-method.
    def inspect
      ::Syslog.inspect
    end
  end
end
