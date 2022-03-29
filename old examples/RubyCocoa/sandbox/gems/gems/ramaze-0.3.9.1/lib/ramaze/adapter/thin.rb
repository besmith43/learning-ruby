#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'thin'
require 'rack/handler/thin'

module Ramaze
  module Adapter
    class Thin < Base
      class << self

        # start server on given host and port.
        def run_server host, port
          server = ::Thin::Server.new(host, port, self)
          ::Thin::Logging.silent = true
          server.timeout = 3

          thread = Thread.new{ server.start }
          thread[:adapter] = server
          thread
        end
      end
    end
  end
end
