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

module Ramaze

  # Helper for quickly push out files with the proper mimetype.

  module Helper::SendFile
    # Sets Content-Type to the mimetype of the file and opens the file you pass
    # it, then throws :respond to finish off the request.

    def send_file(file, mime_type = Tool::MIME.type_for(file))
      response.header["Content-Type"] = mime_type
      response.body = File.open(file)
      throw(:respond)
    end
  end
end
