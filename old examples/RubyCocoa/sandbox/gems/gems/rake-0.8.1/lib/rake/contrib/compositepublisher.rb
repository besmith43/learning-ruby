#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

module Rake

  # Manage several publishers as a single entity.
  class CompositePublisher
    def initialize
      @publishers = []
    end
    
    # Add a publisher to the composite.
    def add(pub)
      @publishers << pub
    end
    
    # Upload all the individual publishers.
    def upload
      @publishers.each { |p| p.upload }
    end
  end

end


