#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

spec_require 'ruby-prof'

Ramaze.contrib :profiling

class MainController < Ramaze::Controller
  def index
    100.times {"h" + "e" + "l" + "l" + "o"}
  end
end

output = StringIO.new
Ramaze::Inform.loggers << Ramaze::Informer.new(output)

describe 'Profiling' do
  behaves_like "http"
  ramaze

  it "should profile" do
    get('/')
    output.string.should =~ /Thread ID:\s\d+/
    output.string.should =~ /Total:/
    output.string.should =~ /self\s+total\s+self\s+wait\s+child\s+call/
  end
end
