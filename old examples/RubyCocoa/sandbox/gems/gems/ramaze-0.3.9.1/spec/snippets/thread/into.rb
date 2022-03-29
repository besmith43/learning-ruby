#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

class TCThreadIntoController < Ramaze::Controller
  map :/

  def hello
    Thread.into('goodbye') do |str|
      "#{Ramaze::Action.current.name}, #{str}"
    end.value
  end
end

describe 'Thread.into' do
  behaves_like 'http'
  ramaze

  it 'should provide access to thread vars' do
    get('/hello').body.should == 'hello, goodbye'
  end
end
