#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'rack'
require 'rack/handler/webrick'
require 'net/http'

# The code for this is inspired by Capybara's server:
#   http://github.com/jnicklas/capybara/blob/0.3.9/lib/capybara/server.rb
module VCR
  class LocalhostServer
    READY_MESSAGE = "VCR server ready"

    class Identify
      def initialize(app)
        @app = app
      end

      def call(env)
        if env["PATH_INFO"] == "/__identify__"
          [200, {}, [VCR::LocalhostServer::READY_MESSAGE]]
        else
          @app.call(env)
        end
      end
    end

    attr_reader :port

    def initialize(rack_app, port = nil)
      @port = port || find_available_port
      @rack_app = rack_app
      concurrently { boot }
      wait_until(10, "Boot failed.") { booted? }
    end

    private

    def find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end

    def boot
      # Use WEBrick since it's part of the ruby standard library and is available on all ruby interpreters.
      options = { :Port => port }
      options.merge!(:AccessLog => [], :Logger => WEBrick::BasicLog.new(StringIO.new)) unless ENV['VERBOSE_SERVER']
      Rack::Handler::WEBrick.run(Identify.new(@rack_app), options)
    end

    def booted?
      res = ::Net::HTTP.get_response("localhost", '/__identify__', port)
      if res.is_a?(::Net::HTTPSuccess) or res.is_a?(::Net::HTTPRedirection)
        return res.body == READY_MESSAGE
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false
    end

    def concurrently
      if should_use_subprocess?
        pid = Process.fork do
          trap(:INT) { ::Rack::Handler::WEBrick.shutdown }
          yield
          exit # manually exit; otherwise this sub-process will re-run the specs that haven't run yet.
        end

        at_exit do
          Process.kill('INT', pid)
          begin
            Process.wait(pid)
          rescue Errno::ECHILD
            # ignore this error...I think it means the child process has already exited.
          end
        end
      else
        # JRuby doesn't support forking.
        # Rubinius does, but there's a weird issue with the booted? check not working,
        # so we're just using a thread for now.
        Thread.new { yield }
      end
    end

    def should_use_subprocess?
      false
    end

    def wait_until(timeout, error_message, &block)
      start_time = Time.now

      while true
        return if yield
        raise TimeoutError.new(error_message) if (Time.now - start_time) > timeout
        sleep(0.05)
      end
    end
  end
end

