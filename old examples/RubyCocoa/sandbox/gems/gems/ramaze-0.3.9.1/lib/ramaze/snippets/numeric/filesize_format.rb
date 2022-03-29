#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

class Numeric
  FILESIZE_FORMAT = [
      ['%.1fT', 1 << 40],
      ['%.1fG', 1 << 30],
      ['%.1fM', 1 << 20],
      ['%.1fK', 1 << 10],
    ]

  def filesize_format
    FILESIZE_FORMAT.each do |format, size|
      return format % (self.to_f / size) if self >= size
    end

    self.to_s
  end
end
