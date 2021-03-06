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

require 'rack/request'
require 'rack/mock'

context "Rack::Request" do
  specify "wraps the rack variables" do
    req = Rack::Request.new(Rack::MockRequest.env_for("http://example.com:8080/"))

    req.body.should.respond_to? :gets
    req.scheme.should.equal "http"
    req.request_method.should.equal "GET"

    req.should.be.get
    req.should.not.be.post
    req.should.not.be.put
    req.should.not.be.delete

    req.script_name.should.equal ""
    req.path_info.should.equal "/"
    req.query_string.should.equal ""

    req.host.should.equal "example.com"
    req.port.should.equal 8080
  end

  specify "can figure out the correct host" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("/", "HTTP_HOST" => "www2.example.org")
    req.host.should.equal "www2.example.org"

    req = Rack::Request.new \
      Rack::MockRequest.env_for("/", "SERVER_NAME" => "example.org:9292")
    req.host.should.equal "example.org"
  end

  specify "can parse the query string" do
    req = Rack::Request.new(Rack::MockRequest.env_for("/?foo=bar&quux=bla"))
    req.query_string.should.equal "foo=bar&quux=bla"
    req.GET.should.equal "foo" => "bar", "quux" => "bla"
    req.POST.should.be.empty
    req.params.should.equal "foo" => "bar", "quux" => "bla"
  end

  specify "can parse POST data" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("/?foo=quux", :input => "foo=bar&quux=bla")
    req.query_string.should.equal "foo=quux"
    req.GET.should.equal "foo" => "quux"
    req.POST.should.equal "foo" => "bar", "quux" => "bla"
    req.params.should.equal "foo" => "bar", "quux" => "bla"
  end

  specify "can get value by key from params with #[]" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("?foo=quux")
    req['foo'].should.equal 'quux'
    req[:foo].should.equal 'quux'
  end

  specify "can set value to key on params with #[]=" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("?foo=duh")
    req['foo'].should.equal 'duh'
    req[:foo].should.equal 'duh'
    req.params.should.equal 'foo' => 'duh'

    req['foo'] = 'bar'
    req.params.should.equal 'foo' => 'bar'
    req['foo'].should.equal 'bar'
    req[:foo].should.equal 'bar'

    req[:foo] = 'jaz'
    req.params.should.equal 'foo' => 'jaz'
    req['foo'].should.equal 'jaz'
    req[:foo].should.equal 'jaz'
  end

  specify "values_at answers values by keys in order given" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("?foo=baz&wun=der&bar=ful")
    req.values_at('foo').should.equal ['baz']
    req.values_at('foo', 'wun').should.equal ['baz', 'der']
    req.values_at('bar', 'foo', 'wun').should.equal ['ful', 'baz', 'der']
  end

  specify "referrer should be extracted correct" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("/", "HTTP_REFERER" => "/some/path")
    req.referer.should.equal "/some/path"

    req = Rack::Request.new \
      Rack::MockRequest.env_for("/")
    req.referer.should.equal "/"
  end

  specify "can cache, but invalidates the cache" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("/?foo=quux", :input => "foo=bar&quux=bla")
    req.GET.should.equal "foo" => "quux"
    req.GET.should.equal "foo" => "quux"
    req.env["QUERY_STRING"] = "bla=foo"
    req.GET.should.equal "bla" => "foo"
    req.GET.should.equal "bla" => "foo"

    req.POST.should.equal "foo" => "bar", "quux" => "bla"
    req.POST.should.equal "foo" => "bar", "quux" => "bla"
    req.env["rack.input"] = StringIO.new("foo=bla&quux=bar")
    req.POST.should.equal "foo" => "bla", "quux" => "bar"
    req.POST.should.equal "foo" => "bla", "quux" => "bar"
  end

  specify "can figure out if called via XHR" do
    req = Rack::Request.new(Rack::MockRequest.env_for(""))
    req.should.not.be.xhr

    req = Rack::Request.new \
      Rack::MockRequest.env_for("", "HTTP_X_REQUESTED_WITH" => "XMLHttpRequest")
    req.should.be.xhr
  end

  specify "can parse cookies" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for("", "HTTP_COOKIE" => "foo=bar;quux=h&m")
    req.cookies.should.equal "foo" => "bar", "quux" => "h&m"
    req.cookies.should.equal "foo" => "bar", "quux" => "h&m"
    req.env.delete("HTTP_COOKIE")
    req.cookies.should.equal({})
  end

  specify "parses cookies according to RFC 2109" do
    req = Rack::Request.new \
      Rack::MockRequest.env_for('', 'HTTP_COOKIE' => 'foo=bar;foo=car')
    req.cookies.should.equal 'foo' => 'bar'
  end

  specify "provides setters" do
    req = Rack::Request.new(e=Rack::MockRequest.env_for(""))
    req.script_name.should.equal ""
    req.script_name = "/foo"
    req.script_name.should.equal "/foo"
    e["SCRIPT_NAME"].should.equal "/foo"

    req.path_info.should.equal "/"
    req.path_info = "/foo"
    req.path_info.should.equal "/foo"
    e["PATH_INFO"].should.equal "/foo"
  end

  specify "provides the original env" do
    req = Rack::Request.new(e=Rack::MockRequest.env_for(""))
    req.env.should.be e
  end

  specify "can restore the URL" do
    Rack::Request.new(Rack::MockRequest.env_for("")).url.
      should.equal "http://example.org/"
    Rack::Request.new(Rack::MockRequest.env_for("", "SCRIPT_NAME" => "/foo")).url.
      should.equal "http://example.org/foo/"
    Rack::Request.new(Rack::MockRequest.env_for("/foo")).url.
      should.equal "http://example.org/foo"
    Rack::Request.new(Rack::MockRequest.env_for("?foo")).url.
      should.equal "http://example.org/?foo"
    Rack::Request.new(Rack::MockRequest.env_for("http://example.org:8080/")).url.
      should.equal "http://example.org:8080/"
    Rack::Request.new(Rack::MockRequest.env_for("https://example.org/")).url.
      should.equal "https://example.org/"

    Rack::Request.new(Rack::MockRequest.env_for("https://example.com:8080/foo?foo")).url.
      should.equal "https://example.com:8080/foo?foo"
  end

  specify "can restore the full path" do
    Rack::Request.new(Rack::MockRequest.env_for("")).fullpath.
      should.equal "/"
    Rack::Request.new(Rack::MockRequest.env_for("", "SCRIPT_NAME" => "/foo")).fullpath.
      should.equal "/foo/"
    Rack::Request.new(Rack::MockRequest.env_for("/foo")).fullpath.
      should.equal "/foo"
    Rack::Request.new(Rack::MockRequest.env_for("?foo")).fullpath.
      should.equal "/?foo"
    Rack::Request.new(Rack::MockRequest.env_for("http://example.org:8080/")).fullpath.
      should.equal "/"
    Rack::Request.new(Rack::MockRequest.env_for("https://example.org/")).fullpath.
      should.equal "/"

    Rack::Request.new(Rack::MockRequest.env_for("https://example.com:8080/foo?foo")).fullpath.
      should.equal "/foo?foo"
  end

  specify "can parse multipart form data" do
    # Adapted from RFC 1867.
    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="reply"\r
\r
yes\r
--AaB03x\r
content-disposition: form-data; name="fileupload"; filename="dj.jpg"\r
Content-Type: image/jpeg\r
Content-Transfer-Encoding: base64\r
\r
/9j/4AAQSkZJRgABAQAAAQABAAD//gA+Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcg\r
--AaB03x--\r
EOF
    req = Rack::Request.new Rack::MockRequest.env_for("/",
                      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
                      "CONTENT_LENGTH" => input.size,
                      :input => input)

    req.POST.should.include "fileupload"
    req.POST.should.include "reply"

    req.POST["reply"].should.equal "yes"

    f = req.POST["fileupload"]
    f.should.be.kind_of Hash
    f[:type].should.equal "image/jpeg"
    f[:filename].should.equal "dj.jpg"
    f.should.include :tempfile
    f[:tempfile].size.should.equal 76
  end

  specify "can parse big multipart form data" do
    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="huge"; filename="huge"\r
\r
#{"x"*32768}\r
--AaB03x\r
content-disposition: form-data; name="mean"; filename="mean"\r
\r
--AaB03xha\r
--AaB03x--\r
EOF
    req = Rack::Request.new Rack::MockRequest.env_for("/",
                      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
                      "CONTENT_LENGTH" => input.size,
                      :input => input)
    
    req.POST["huge"][:tempfile].size.should.equal 32768
    req.POST["mean"][:tempfile].size.should.equal 10
    req.POST["mean"][:tempfile].read.should.equal "--AaB03xha"
  end

  specify "can detect invalid multipart form data" do
    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="huge"; filename="huge"\r
EOF
    req = Rack::Request.new Rack::MockRequest.env_for("/",
                      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
                      "CONTENT_LENGTH" => input.size,
                      :input => input)

    lambda { req.POST }.should.raise(EOFError)

    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="huge"; filename="huge"\r
\r
foo\r
EOF
    req = Rack::Request.new Rack::MockRequest.env_for("/",
                      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
                      "CONTENT_LENGTH" => input.size,
                      :input => input)

    lambda { req.POST }.should.raise(EOFError)

    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="huge"; filename="huge"\r
\r
foo\r
EOF
    req = Rack::Request.new Rack::MockRequest.env_for("/",
                      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
                      "CONTENT_LENGTH" => input.size,
                      :input => input)

    lambda { req.POST }.should.raise(EOFError)
  end

  specify "does conform to the Rack spec" do
    app = lambda { |env|
      content = Rack::Request.new(env).POST["file"].inspect
      [200, {"Content-Type" => "text/html"}, content]
    }

    input = <<EOF
--AaB03x\r
content-disposition: form-data; name="reply"\r
\r
yes\r
--AaB03x\r
content-disposition: form-data; name="fileupload"; filename="dj.jpg"\r
Content-Type: image/jpeg\r
Content-Transfer-Encoding: base64\r
\r
/9j/4AAQSkZJRgABAQAAAQABAAD//gA+Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcg\r
--AaB03x--\r
EOF
    res = Rack::MockRequest.new(Rack::Lint.new(app)).get "/",
      "CONTENT_TYPE" => "multipart/form-data, boundary=AaB03x",
      "CONTENT_LENGTH" => input.size.to_s, "rack.input" => StringIO.new(input)

    res.should.be.ok
  end
end
