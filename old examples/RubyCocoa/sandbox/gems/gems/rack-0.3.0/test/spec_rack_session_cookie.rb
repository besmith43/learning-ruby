#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'

require 'rack/session/cookie'
require 'rack/mock'
require 'rack/response'

context "Rack::Session::Cookie" do
  incrementor = lambda { |env|
    env["rack.session"]["counter"] ||= 0
    env["rack.session"]["counter"] += 1
    Rack::Response.new(env["rack.session"].inspect).to_a
  }

  specify "creates a new cookie" do
    res = Rack::MockRequest.new(Rack::Session::Cookie.new(incrementor)).get("/")
    res["Set-Cookie"].should.match("rack.session=")
    res.body.should.equal '{"counter"=>1}'
  end

  specify "loads from a cookie" do
    res = Rack::MockRequest.new(Rack::Session::Cookie.new(incrementor)).get("/")
    cookie = res["Set-Cookie"]
    res = Rack::MockRequest.new(Rack::Session::Cookie.new(incrementor)).
      get("/", "HTTP_COOKIE" => cookie)
    res.body.should.equal '{"counter"=>2}'
    cookie = res["Set-Cookie"]
    res = Rack::MockRequest.new(Rack::Session::Cookie.new(incrementor)).
      get("/", "HTTP_COOKIE" => cookie)
    res.body.should.equal '{"counter"=>3}'
  end

  specify "survives broken cookies" do
    res = Rack::MockRequest.new(Rack::Session::Cookie.new(incrementor)).
      get("/", "HTTP_COOKIE" => "rack.session=blarghfasel")
    res.body.should.equal '{"counter"=>1}'
  end

  bigcookie = lambda { |env|
    env["rack.session"]["cookie"] = "big" * 3000
    Rack::Response.new(env["rack.session"].inspect).to_a
  }

  specify "barks on too big cookies" do
    lambda {
      Rack::MockRequest.new(Rack::Session::Cookie.new(bigcookie)).
        get("/", :fatal => true)
    }.should.raise(Rack::MockRequest::FatalWarning)
  end
end
