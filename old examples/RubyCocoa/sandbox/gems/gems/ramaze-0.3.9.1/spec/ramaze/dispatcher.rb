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

class TCDispatcherController < Ramaze::Controller
  map '/'

  def index
    "Hello, World!"
  end
end

describe "Dispatcher" do
  behaves_like 'http'
  ramaze :ignore => ['/favicon.ico', '/robots.txt'],
    :ignore_body => 'File not found'

  it 'should resolve a normal request' do
    page = get('/')
    page.status.should == 200
    page.body.should == 'Hello, World!'
  end

  it 'should ignore /foo.ico' do
    Ramaze::Global.ignore = ['/foo.ico']
    page = get('/foo.ico')
    page.status.should == 404
    page.body.should == 'File not found'
  end
end
