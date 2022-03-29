#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'ramaze'
require 'ramaze/spec/helper'

require __DIR__/'..'/'start'

describe MainController do
  behaves_like 'http', 'xpath'
  ramaze :template_root => __DIR__/'../view',
         :public_root => __DIR__/'../public'

  it 'should show start page' do
    got = get('/')
    got.status.should == 200
    got.at('//title').text.strip.should ==
      MainController.new.index
  end

  it 'should show /notemplate' do
    got = get('/notemplate')
    got.status.should == 200
    got.at('//div').text.strip.should ==
      MainController.new.notemplate
  end
end
