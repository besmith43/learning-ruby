#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---


class BasenameFormatter < OSX::NSFormatter

  # ...



  include OSX
  ib_outlet :cell

  def awakeFromNib; @cell.formatter = self;  end

  def stringForObjectValue(o)   # (1)
    return '' if o.nil?
    File.basename(o)
  end

  # TODO: this is bad design - too many places in the code know a 
  # little bit about the Source. That knowledge should be encapsulated,
  # and puts somewhere other than right next to the GUI.

  def getObjectValue_forString_errorDescription(objptr, s, errdesc)  # (2)
    unless s.to_ruby =~ /\.rb$/
      return error("The Source must end in '.rb'. \n'#{s}' does not.",
                   errdesc)
    end

    unless file_exists?(s)
      return error("The Source must exist.\n'#{s}' does not.", errdesc)
    end

    objptr.assign(s)
    return true
  end

  def editingStringForObjectValue(o)   # (3) 
    return '' if o.nil?
    o.to_ns.stringByAbbreviatingWithTildeInPath  # (4) 
  end


  testable   # (5) 


  def file_exists?(name)
    name = name.stringByExpandingTildeInPath   # (6) 
    NSFileManager.defaultManager.fileExistsAtPath(name)  # (7)
  end


  # ...



  def error(msg, errdesc)
    errdesc.assign(msg) if errdesc
    false
  end

end


