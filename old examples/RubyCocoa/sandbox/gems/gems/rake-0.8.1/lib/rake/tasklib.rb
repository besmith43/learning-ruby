#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'rake'

module Rake

  # Base class for Task Libraries.
  class TaskLib

    include Cloneable

    # Make a symbol by pasting two strings together. 
    def paste(a,b)
      (a.to_s + b.to_s).intern
    end
  end

end
