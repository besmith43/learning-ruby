#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class TranslatorEnlister < OSX::NSObject
  include OSX
  attr_reader :choices, :favorite
  
  def init
    @favorite = "sample webapp com.exampler.counting"

    @choices = [
      @favorite,
      "for other apps: use.dot.format.name"
    ]
    super_init
  end

  def awakeFromNib
    NSLog("TranslatorEnlister awakes from Nib.")
  end
end
