#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Object
  def blank?
    nil? || (respond_to?(:empty?) && empty?)
  end
end

class Numeric
  def blank?
    false
  end
end

class NilClass
  def blank?
    true
  end
end

class TrueClass
  def blank?
    false
  end
end

class FalseClass
  def blank?
    true
  end
end

class String
  def blank?
    empty? || self =~ /\A\s*\Z/
  end
end
