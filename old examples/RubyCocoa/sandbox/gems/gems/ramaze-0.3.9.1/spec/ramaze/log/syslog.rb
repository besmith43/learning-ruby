#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

require 'ramaze/log/syslog'

describe 'Syslog' do
  it 'should do something' do
    syslog = Ramaze::Syslog.new
    syslog.send(:ident).should =~ /#{Regexp.escape(__FILE__)}$/
  end
end
