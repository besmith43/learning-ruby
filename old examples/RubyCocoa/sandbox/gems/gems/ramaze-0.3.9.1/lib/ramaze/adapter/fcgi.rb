#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

module Ramaze
  Global.test_connections = false

  module Adapter
    # Our Fcgi adapter acts as wrapper for the Rack::Handler::FastCGI.
    class Fcgi < Base
      class << self

        # start FastCGI in a new thread, host and port parameter are only taken
        # to make it compatible with other adapters but have no influence and
        # can be omitted
        def run_server host = nil, ports = nil
          Thread.new do
            Thread.current[:task] = :cgi
            Rack::Handler::FastCGI.run(self)
          end
        end
      end
    end
  end
end
