#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class BasenameFormatter < NSFormatter
  attr_writer :cell

  def awakeFromNib; @cell.formatter = self;  end

  def stringForObjectValue(o)   
    return '' if o.nil?
    File.basename(o)
  end

  # TODO: this is bad design - too many places in the code know a 
  # little bit about the Source. That knowledge should be encapsulated,
  # and puts somewhere other than right next to the GUI.

  def getObjectValue(objptr, forString: s, errorDescription: errdesc)
    unless s =~ /\.rb$/
      return error("The Source must end in '.rb'. \n'#{s}' does not.",
                   errdesc)
    end

    unless file_exists?(s)
      return error("The Source must exist.\n'#{s}' does not.", errdesc)
    end

    objptr.assign(s)
    return true
  end

  def editingStringForObjectValue(o)   
    return '' if o.nil?
    o.stringByAbbreviatingWithTildeInPath  
  end

  testable   

  def file_exists?(name)
    name = name.stringByExpandingTildeInPath   
    NSFileManager.defaultManager.fileExistsAtPath(name)  
  end

  def error(msg, errdesc)
    errdesc.assign(msg) if errdesc
    false
  end
end
