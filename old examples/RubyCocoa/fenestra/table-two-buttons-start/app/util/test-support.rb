#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Class
  alias_method :testable, :protected
end

module Fenestrable
  class Fenestra
    def initialize(owner)
      @owner = owner
    end

    def method_missing(message, *args)
      @owner.send(message, *args)
    end
  end

  attr_accessor :fenestra

  def self.extended(object)
    object.fenestra = Fenestra.new(object)
  end

end
