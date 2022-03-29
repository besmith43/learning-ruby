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

class TCStackHelperController < Ramaze::Controller
  map :/
  helper :stack, :aspect

  def index
    session.inspect
  end

  def foo
    call Rs(:login) unless logged_in?
    "logged in"
  end

  def bar
    call Rs(:login) unless logged_in?
    request.params.inspect
  end

  def secure
    logged_in? ? 'secret content' : 'please login'
  end

  def login
    session[:logged_in] = true
    answer
  end

  def logout
    session.clear
  end

  private

  def logged_in?
    session[:logged_in]
  end
end

describe "StackHelper" do
  behaves_like 'browser'
  ramaze(:adapter => :webrick)

  it "conventional login" do
    Browser.new do
      get('/secure').should == 'please login'
      get('/login')
      get('/secure').should == 'secret content'
      get('/logout')
    end
  end

  it "indirect login" do
    Browser.new do
      get('/')
      get('/foo').should == 'logged in'
      get('/secure').should == 'secret content'
      eget('/').should == {:logged_in => true}
    end
  end

  it "indirect login with params" do
    Browser.new do
      get('/')
      eget('/bar', 'x' => 'y').should == {'x' => 'y'}
      eget('/').should == {:logged_in => true}
    end
  end
end
