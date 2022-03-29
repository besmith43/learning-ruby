#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/linking'

describe 'Linking' do
  behaves_like 'http'
  ramaze

  it 'should provide a link to help' do
    r = get('/').body
    r.should.include('<a href="/help">Help?</a>')
  end

  it 'should provide a link to another controller' do
    r = get('/help').body
    r.should.include('<a href="/link_to/another">A Different Controller</a>')
  end

end
