#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

class TCFileHelper < Ramaze::Controller
  map '/'

  def index
    send_file(__FILE__)
  end
end

describe 'FileHelper' do
  behaves_like 'http'
  ramaze

  it 'serving a file' do
    get('/').body.strip.should == File.read(__FILE__).strip
  end
end
