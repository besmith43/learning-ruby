#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

class BooleanCellFormatter < OSX::NSFormatter
  include OSX

  ib_outlet :cell

  def awakeFromNib
    @cell.formatter = self
  end


  def stringForObjectValue(o)
    o == true.to_ns ? "yes" : "no"
  end


  def getObjectValue_forString_errorDescription(objptr, s, errdesc)
    case s.to_ruby.downcase
      when 'yes': objptr.assign(true)
      when 'no': objptr.assign(false)
      else return false
    end
    true
  end

  def isPartialStringValid_newEditingString_errorDescription(s, new_s, errdesc)
    def s.could_become?(target)
      self.to_ruby.downcase == target[0...self.size]
    end
    
    valid = s.could_become?('yes') || s.could_become?('no')
    (valid ? 1 : 0).to_ns
  end
end

