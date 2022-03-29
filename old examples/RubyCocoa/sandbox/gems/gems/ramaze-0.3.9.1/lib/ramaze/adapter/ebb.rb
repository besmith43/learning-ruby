#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'ebb'

module Ramaze
  module Adapter
    class Ebb < Base
      class << self

        # start server on given host and port.
        def run_server host, port
          server = ::Ebb::Server.new(self, :port => port)

          thread = Thread.new{ server.start }
          thread[:adapter] = server
          thread
        end
      end
    end
  end

  class Response
    def finish(&block)
      @block = block

      if [201, 204, 304].include?(status.to_i)
        header.delete "Content-Type"
        [status.to_i, header.to_hash, '']
      else
        [status.to_i, header.to_hash, [body].flatten.join]
      end
    end
  end
end
