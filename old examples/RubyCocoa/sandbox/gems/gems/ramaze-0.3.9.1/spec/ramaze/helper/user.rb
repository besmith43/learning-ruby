#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

class MockSequelUser
  # mocks what User[:name => 'arthur', :password => '42'] would do
  def self.[](hash)
    name = hash[:name] || hash['name']
    pass = hash[:password] || hash['password']
    new if name == 'arthur' and pass == '42'
  end

  def profile
    "Arthur Dent, fearful human in outer space!"
  end
end

class HelperUser < Ramaze::Controller
  map '/'
  helper :user
  trait :user_model => MockSequelUser

  def status
    user.logged_in?.to_s
  end

  def login
    user.login
  end

  def profile
    user.profile
  end
end

describe Ramaze::Helper::User do
  behaves_like 'browser'
  ramaze :adapter => :webrick

  should 'login' do
    Browser.new do
      get('/status').should == 'false'
      get('/login', 'name' => 'arthur', 'password' => '42')
      get('/status').should == 'true'
      get('/profile').should == MockSequelUser.new.profile
    end
  end
end
