#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

class TranslatorPreference < OSX::NSObject
  Properties = [:display_name, :app_name, :class_name, :favorite, :source]
  attr_accessor *Properties


  # Override writers that need special handling

  def favorite=(value)
    @favorite = value
    @favorite = false if @favorite == 0
  end



  def initWithHash(hash)
    Properties.each do | prop |
      writer = prop.to_s + '='
      self.send(writer, hash[prop])
    end
    self
  end



  def encodeWithCoder(coder)
    Properties.each do | prop |
      value = self.send(prop)    # (1)
      coder.encodeObject_forKey(value, prop)  # (2) 
    end
  end



  def initWithCoder(coder)
    hash = {}
    Properties.each do | prop | 
      hash[prop] = coder.decodeObjectForKey(prop)
    end
    initWithHash(hash)
  end



  def description
    "<#{self.class}: #{display_name}/#{app_name}/#{class_name}" +
      " favorite: #{favorite} from '#{source}'."
  end
  alias inspect to_s


end


