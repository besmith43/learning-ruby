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

require 'ramaze/log/logging'
require 'ramaze/log/hub'
require 'ramaze/log/informer'

begin
  require 'win32console' if RUBY_PLATFORM =~ /win32/i
rescue LoadError => ex
  puts ex
  puts "For nice colors on windows, please `gem install win32console`"
  Ramaze::Informer.trait[:colorize] = false
end

module Ramaze
  autoload :Analogger, "ramaze/log/analogger.rb"
  autoload :Knotify,   "ramaze/log/knotify.rb"
  autoload :Syslog,    "ramaze/log/syslog.rb"
  autoload :Growl,     "ramaze/log/growl.rb"
  autoload :Xosd,      "ramaze/log/xosd.rb"
  autoload :Logger,    "ramaze/log/logger.rb"
  autoload :Inform,    "ramaze/inform"

  unless defined?(Log)
    Log = LogHub.new(Informer)
  end
end
