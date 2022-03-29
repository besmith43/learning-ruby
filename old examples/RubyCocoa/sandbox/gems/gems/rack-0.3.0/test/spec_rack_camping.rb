#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'
require 'stringio'
require 'uri'

require 'rack/mock'

$-w, w = nil, $-w               # yuck
require 'camping'
require 'rack/adapter/camping'

Camping.goes :CampApp
module CampApp
  module Controllers
    class HW < R('/')
      def get
        @headers["X-Served-By"] = URI("http://rack.rubyforge.org")
        "Camping works!"
      end

      def post
        "Data: #{input.foo}"
      end
    end
  end
end
$-w = w

context "Rack::Adapter::Camping" do
  specify "works with GET" do
    res = Rack::MockRequest.new(Rack::Adapter::Camping.new(CampApp)).
      get("/")

    res.should.be.ok
    res["Content-Type"].should.equal "text/html"
    res["X-Served-By"].should.equal "http://rack.rubyforge.org"

    res.body.should.equal "Camping works!"
  end

  specify "works with POST" do
    res = Rack::MockRequest.new(Rack::Adapter::Camping.new(CampApp)).
      post("/", :input => "foo=bar")

    res.should.be.ok
    res.body.should.equal "Data: bar"
  end
end
