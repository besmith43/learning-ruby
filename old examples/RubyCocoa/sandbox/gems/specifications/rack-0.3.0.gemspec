Gem::Specification.new do |s|
  s.name = %q{rack}
  s.version = "0.3.0"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Christian Neukirchen"]
  s.cert_chain = nil
  s.date = %q{2008-02-25}
  s.default_executable = %q{rackup}
  s.description = %q{Rack provides minimal, modular and adaptable interface for developing web applications in Ruby.  By wrapping HTTP requests and responses in the simplest way possible, it unifies and distills the API for web servers, web frameworks, and software in between (the so-called middleware) into a single method call.  Also see http://rack.rubyforge.org.}
  s.email = %q{chneukirchen@gmail.com}
  s.executables = ["rackup"]
  s.extra_rdoc_files = ["README", "SPEC", "RDOX", "KNOWN-ISSUES"]
  s.files = ["AUTHORS", "bin/rackup", "contrib/rack_logo.svg", "COPYING", "example/lobster.ru", "example/protectedlobster.rb", "example/protectedlobster.ru", "KNOWN-ISSUES", "lib/rack/adapter/camping.rb", "lib/rack/auth/abstract/handler.rb", "lib/rack/auth/abstract/request.rb", "lib/rack/auth/basic.rb", "lib/rack/auth/digest/md5.rb", "lib/rack/auth/digest/nonce.rb", "lib/rack/auth/digest/params.rb", "lib/rack/auth/digest/request.rb", "lib/rack/auth/openid.rb", "lib/rack/builder.rb", "lib/rack/cascade.rb", "lib/rack/commonlogger.rb", "lib/rack/file.rb", "lib/rack/handler/cgi.rb", "lib/rack/handler/fastcgi.rb", "lib/rack/handler/lsws.rb", "lib/rack/handler/mongrel.rb", "lib/rack/handler/scgi.rb", "lib/rack/handler/webrick.rb", "lib/rack/lint.rb", "lib/rack/lobster.rb", "lib/rack/mock.rb", "lib/rack/recursive.rb", "lib/rack/reloader.rb", "lib/rack/request.rb", "lib/rack/response.rb", "lib/rack/session/cookie.rb", "lib/rack/session/pool.rb", "lib/rack/showexceptions.rb", "lib/rack/showstatus.rb", "lib/rack/static.rb", "lib/rack/urlmap.rb", "lib/rack/utils.rb", "lib/rack.rb", "Rakefile", "README", "test/cgi/lighttpd.conf", "test/cgi/test", "test/cgi/test.fcgi", "test/cgi/test.ru", "test/spec_rack_auth_basic.rb", "test/spec_rack_auth_digest.rb", "test/spec_rack_builder.rb", "test/spec_rack_camping.rb", "test/spec_rack_cascade.rb", "test/spec_rack_cgi.rb", "test/spec_rack_commonlogger.rb", "test/spec_rack_fastcgi.rb", "test/spec_rack_file.rb", "test/spec_rack_lint.rb", "test/spec_rack_lobster.rb", "test/spec_rack_mock.rb", "test/spec_rack_mongrel.rb", "test/spec_rack_recursive.rb", "test/spec_rack_request.rb", "test/spec_rack_response.rb", "test/spec_rack_session_cookie.rb", "test/spec_rack_session_pool.rb", "test/spec_rack_showexceptions.rb", "test/spec_rack_showstatus.rb", "test/spec_rack_static.rb", "test/spec_rack_urlmap.rb", "test/spec_rack_utils.rb", "test/spec_rack_webrick.rb", "test/testrequest.rb", "SPEC", "RDOX"]
  s.has_rdoc = true
  s.homepage = %q{http://rack.rubyforge.org}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{rack}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{a modular Ruby webserver interface}
  s.test_files = ["test/spec_rack_auth_basic.rb", "test/spec_rack_auth_digest.rb", "test/spec_rack_builder.rb", "test/spec_rack_camping.rb", "test/spec_rack_cascade.rb", "test/spec_rack_cgi.rb", "test/spec_rack_commonlogger.rb", "test/spec_rack_fastcgi.rb", "test/spec_rack_file.rb", "test/spec_rack_lint.rb", "test/spec_rack_lobster.rb", "test/spec_rack_mock.rb", "test/spec_rack_mongrel.rb", "test/spec_rack_recursive.rb", "test/spec_rack_request.rb", "test/spec_rack_response.rb", "test/spec_rack_session_cookie.rb", "test/spec_rack_session_pool.rb", "test/spec_rack_showexceptions.rb", "test/spec_rack_showstatus.rb", "test/spec_rack_static.rb", "test/spec_rack_urlmap.rb", "test/spec_rack_utils.rb", "test/spec_rack_webrick.rb"]
end
