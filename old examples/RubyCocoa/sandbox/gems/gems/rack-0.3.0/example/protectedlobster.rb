#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rack'
require 'rack/lobster'

lobster = Rack::Lobster.new

protected_lobster = Rack::Auth::Basic.new(lobster) do |username, password|
  'secret' == password
end

protected_lobster.realm = 'Lobster 2.0'

pretty_protected_lobster = Rack::ShowStatus.new(Rack::ShowExceptions.new(protected_lobster))

Rack::Handler::WEBrick.run pretty_protected_lobster, :Port => 9292
