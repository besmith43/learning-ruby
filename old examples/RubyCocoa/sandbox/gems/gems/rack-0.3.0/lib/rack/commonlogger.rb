#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Rack
  # Rack::CommonLogger forwards every request to an +app+ given, and
  # logs a line in the Apache common log format to the +logger+, or
  # rack.errors by default.

  class CommonLogger
    def initialize(app, logger=nil)
      @app = app
      @logger = logger
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      @env = env
      @logger ||= self
      @time = Time.now
      @status, @header, @body = @app.call(env)
      [@status, @header, self]
    end

    # By default, log to rack.errors.
    def <<(str)
      @env["rack.errors"].write(str)
      @env["rack.errors"].flush
    end

    def each
      length = 0
      @body.each { |part|
        length += part.size
        yield part
      }

      @now = Time.now

      # Common Log Format: http://httpd.apache.org/docs/1.3/logs.html#common
      # lilith.local - - [07/Aug/2006 23:58:02] "GET / HTTP/1.1" 500 -
      #             %{%s - %s [%s] "%s %s%s %s" %d %s\n} %
      @logger << %{%s - %s [%s] "%s %s%s %s" %d %s %0.4f\n} %
        [@env["REMOTE_ADDR"] || "-",
         @env["REMOTE_USER"] || "-",
         @now.strftime("%d/%b/%Y %H:%M:%S"),
         @env["REQUEST_METHOD"],
         @env["PATH_INFO"],
         @env["QUERY_STRING"].empty? ? "" : "?"+@env["QUERY_STRING"],
         @env["HTTP_VERSION"],
         @status.to_s[0..3],
         (length.zero? ? "-" : length.to_s),
         @now - @time
        ]
    end
  end
end
