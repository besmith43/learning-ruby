#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'ramaze'

class MainController < Ramaze::Controller
  helper :identity

  def index
    if session[:openid_identity]
      %{<h1>#{flash[:success]}</h1>
        <p>You are logged in as #{session[:openid_identity]}</p>}
    else
      openid_login_form
    end
  end
end

Ramaze::Log.loggers.each{|l| l.log_levels << :dev }
Ramaze.start :adapter => :mongrel
