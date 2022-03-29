#---
# Excerpted from "Working with Ruby Threads",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/jsthreads for more book information.
#---
require 'celluloid/autostart'
require 'net/http'

class XKCDFetcher
  include Celluloid

  def next
    response = Net::HTTP.get_response('dynamic.xkcd.com', '/random/comic/')
    random_comic_url = response['Location']

    random_comic_url
  end
end

