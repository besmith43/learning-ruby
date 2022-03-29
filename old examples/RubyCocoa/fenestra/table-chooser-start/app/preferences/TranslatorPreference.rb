#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class TranslatorPreference < OSX::NSObject
  include PermanentlyIdentifiable

  Properties = [:display_name, :app_name, :class_name, :favorite, :source]
  attr_writer *Properties
  attr_reader *(Properties - [:favorite])
  def favorite
    return true if @favorite == true.to_ns
    return false if @favorite == false.to_ns
    @favorite
  end

  # Override writers that need special handling
  def favorite=(value)
    @favorite = value
    @favorite = false if @favorite == 0
  end

  def init
    initWithHash(:display_name => DEFAULT_TRANSLATOR_DISPLAY_NAME, 
                 :app_name => DEFAULT_TRANSLATOR_APP_NAME,
                 :class_name => DEFAULT_TRANSLATOR_CLASS_NAME,
                 :favorite => false,
                 :source => '')
  end

  def initWithHash(hash)
    Properties.each do | prop |
      writer = prop.to_s + '='
      self.send(writer, hash[prop])
    end
    become_permanently_identifiable
    self
  end

  def encodeWithCoder(coder)
    Properties.each do | prop |
      value = self.send(prop) 
      coder.encodeObject_forKey(value, prop)
    end
    encode_permanent_identity(coder)
  end

  def initWithCoder(coder)
    hash = {}
    Properties.each do | prop | 
      hash[prop] = coder.decodeObjectForKey(prop)
    end
    initWithHash(hash)
    decode_permanent_identity(coder)
    self
  end

  def isEqual(other)
    Properties.each do | p |
      return false unless send(p) == other.send(p)
    end
    true
  end
  alias_method :==, :isEqual

  # Easiest way to satisfy both hash constraints. See tests.
  def hash; 5; end

  def description
    "<#{self.class}: #{display_name}/#{app_name}/#{class_name}" +
      " favorite: #{favorite} from '#{source}'."
  end
  alias inspect to_s

end

