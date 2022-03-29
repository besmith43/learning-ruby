#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/simple_auth'

describe "SimpleAuth" do
  behaves_like 'browser'
  ramaze(:adapter => :webrick)

  it 'should show start page' do
    Browser.new do
      http.basic_authentication "username", "password"
      get('/').should == "Secret Info"
    end

    Browser.new do
      http.basic_authentication "admin", "secret"
      get('/').should == "Secret Info"
    end
  end

  it 'should not show start page' do
    Browser.new do
      lambda{ get('/') }.should.raise
    end

    Browser.new do
      lambda do
        http.basic_authentication "hello", "world"
        lambda{ get('/') }.should.raise
      end
    end
  end
end
