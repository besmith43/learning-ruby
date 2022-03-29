#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'

require 'rack/cascade'
require 'rack/mock'

require 'rack/urlmap'
require 'rack/file'

context "Rack::Cascade" do
  docroot = File.expand_path(File.dirname(__FILE__))
  app1 = Rack::File.new(docroot)

  app2 = Rack::URLMap.new("/crash" => lambda { |env| raise "boom" })

  app3 = Rack::URLMap.new("/foo" => lambda { |env|
                            [200, { "Content-Type" => "text/plain"}, [""]]})

  specify "should dispatch onward on 404 by default" do
    cascade = Rack::Cascade.new([app1, app2, app3])
    Rack::MockRequest.new(cascade).get("/cgi/test").should.be.ok
    Rack::MockRequest.new(cascade).get("/foo").should.be.ok
    Rack::MockRequest.new(cascade).get("/toobad").should.be.not_found
    Rack::MockRequest.new(cascade).get("/cgi/../bla").should.be.forbidden
  end

  specify "should dispatch onward on whatever is passed" do
    cascade = Rack::Cascade.new([app1, app2, app3], [404, 403])
    Rack::MockRequest.new(cascade).get("/cgi/../bla").should.be.not_found
  end

  specify "should fail if empty" do
    lambda { Rack::MockRequest.new(Rack::Cascade.new([])).get("/") }.
      should.raise(ArgumentError)
  end
end
