#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'ramaze'

class MainController < Ramaze::Controller
  def index
    return unless request.post?
    @inspection = h(request.params.pretty_inspect)
    tempfile, filename, @type =
      request[:file].values_at(:tempfile, :filename, :type)
    @extname, @basename = File.extname(filename), File.basename(filename)
    @file_size = tempfile.size

    FileUtils.move(tempfile.path, Ramaze::Global.public_root/@basename)

    @is_image = @type.split('/').first == 'image'
  end
end

Ramaze.start