#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/spec'
require 'testrequest'

context "Rack::Handler::CGI" do
  include TestRequest::Helpers
  
  setup do
    @host = '0.0.0.0'
    @port = 9203
  end

  # Keep this first.
  specify "startup" do
    $pid = fork {
      Dir.chdir File.join(File.dirname(__FILE__), 'cgi')
      exec "lighttpd -D -f lighttpd.conf"
    }
  end

  specify "should respond" do
    lambda {
      GET("/test")
    }.should.not.raise
  end

  specify "should be a lighttpd" do
    GET("/test")
    status.should.be 200
    response["SERVER_SOFTWARE"].should =~ /lighttpd/
    response["HTTP_VERSION"].should.equal "HTTP/1.1"
    response["SERVER_PROTOCOL"].should.equal "HTTP/1.1"
    response["SERVER_PORT"].should.equal "9203"
    response["SERVER_NAME"].should =~ "0.0.0.0"
  end

  specify "should have rack headers" do
    GET("/test")
    response["rack.version"].should.equal [0,1]
    response["rack.multithread"].should.be false
    response["rack.multiprocess"].should.be true
    response["rack.run_once"].should.be true
  end

  specify "should have CGI headers on GET" do
    GET("/test")
    response["REQUEST_METHOD"].should.equal "GET"
    response["SCRIPT_NAME"].should.equal "/test"
    response["REQUEST_PATH"].should.equal "/"
    response["PATH_INFO"].should.be.nil
    response["QUERY_STRING"].should.equal ""
    response["test.postdata"].should.equal ""

    GET("/test/foo?quux=1")
    response["REQUEST_METHOD"].should.equal "GET"
    response["SCRIPT_NAME"].should.equal "/test"
    response["REQUEST_PATH"].should.equal "/"
    response["PATH_INFO"].should.equal "/foo"
    response["QUERY_STRING"].should.equal "quux=1"
  end

  specify "should have CGI headers on POST" do
    POST("/test", {"rack-form-data" => "23"}, {'X-test-header' => '42'})
    status.should.equal 200
    response["REQUEST_METHOD"].should.equal "POST"
    response["SCRIPT_NAME"].should.equal "/test"
    response["REQUEST_PATH"].should.equal "/"
    response["QUERY_STRING"].should.equal ""
    response["HTTP_X_TEST_HEADER"].should.equal "42"
    response["test.postdata"].should.equal "rack-form-data=23"
  end

  specify "should support HTTP auth" do
    GET("/test", {:user => "ruth", :passwd => "secret"})
    response["HTTP_AUTHORIZATION"].should.equal "Basic cnV0aDpzZWNyZXQ="
  end

  specify "should set status" do
    GET("/test?secret")
    status.should.equal 403
    response["rack.url_scheme"].should.equal "http"
  end

  # Keep this last.
  specify "shutdown" do
    Process.kill 15, $pid
    Process.wait($pid).should.equal $pid
  end
end
