#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
gem "assistance", ">= 0.1.2" # because we need Validations

require "assistance"

module Sequel
  class Model
    include Validation
    
    alias_method :save!, :save
    def save(*args)
      return false unless valid?
      save!(*args)
    end
  end
end
