#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'stringio'

class FlexMock
  module RedirectError
    def redirect_error
      require 'stringio'
      old_err = $stderr
      $stderr = StringIO.new
      yield
      $stderr.string
    ensure
      $stderr = old_err
    end
    private :redirect_error
  end
end
