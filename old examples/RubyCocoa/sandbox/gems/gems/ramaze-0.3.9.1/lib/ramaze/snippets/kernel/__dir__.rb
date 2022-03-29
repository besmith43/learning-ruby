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

# Extensions for Kernel

module Kernel
  unless defined?__DIR__

    # This is similar to +__FILE__+ and +__LINE__+, and returns a String
    # representing the directory of the current file is.
    # Unlike +__FILE__+ the path returned is absolute.
    #
    # This method is convenience for the
    #  File.expand_path(File.dirname(__FILE__))
    # idiom.
    #

    def __DIR__()
      filename = caller[0][/(.*?):/, 1]
      File.expand_path(File.dirname(filename))
    end
  end
end
