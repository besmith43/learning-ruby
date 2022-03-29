#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

class TCAdapterController < Ramaze::Controller
  map '/'

  def index
    "The index"
  end
end

ramaze ramaze_options.merge(:spawn => 10)

describe "Adapter" do
  behaves_like "http"

  it 'should do a simple request' do
    get('/').body.should == 'The index'
  end
end
