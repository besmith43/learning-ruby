#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'

require 'rack/showexceptions'
require 'rack/mock'

context "Rack::ShowExceptions" do
  specify "catches exceptions" do
    res = nil
    req = Rack::MockRequest.new(Rack::ShowExceptions.new(lambda { |env|
                                                           raise RuntimeError
                                                         }))
    lambda {
      res = req.get("/")
    }.should.not.raise
    res.should.be.a.server_error
    res.status.should.equal 500

    res.should =~ /RuntimeError/
    res.should =~ /ShowExceptions/
  end
end
