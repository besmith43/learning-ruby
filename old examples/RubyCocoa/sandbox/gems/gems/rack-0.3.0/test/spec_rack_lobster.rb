#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'

require 'rack/lobster'
require 'rack/mock'

context "Rack::Lobster::LambdaLobster" do
  specify "should be a single lambda" do
    Rack::Lobster::LambdaLobster.should.be.kind_of Proc
  end
  
  specify "should look like a lobster" do
    res = Rack::MockRequest.new(Rack::Lobster::LambdaLobster).get("/")
    res.should.be.ok
    res.body.should.include "(,(,,(,,,("
    res.body.should.include "?flip"
  end

  specify "should be flippable" do
    res = Rack::MockRequest.new(Rack::Lobster::LambdaLobster).get("/?flip")
    res.should.be.ok
    res.body.should.include "(,,,(,,(,("
  end
end

context "Rack::Lobster" do
  specify "should look like a lobster" do
    res = Rack::MockRequest.new(Rack::Lobster.new).get("/")
    res.should.be.ok
    res.body.should.include "(,(,,(,,,("
    res.body.should.include "?flip"
    res.body.should.include "crash"
  end

  specify "should be flippable" do
    res = Rack::MockRequest.new(Rack::Lobster.new).get("/?flip=left")
    res.should.be.ok
    res.body.should.include "(,,,(,,(,("
  end

  specify "should provide crashing for testing purposes" do
    lambda {
      Rack::MockRequest.new(Rack::Lobster.new).get("/?flip=crash")
    }.should.raise
  end
end
