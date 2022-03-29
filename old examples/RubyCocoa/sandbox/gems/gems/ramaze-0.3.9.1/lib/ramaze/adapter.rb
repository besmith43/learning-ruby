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

require 'ramaze/trinity'
require 'ramaze/tool/record'
require 'ramaze/adapter/base'

# for OSX compatibility
Socket.do_not_reverse_lookup = true

module Ramaze

  # Shortcut to the HTTP_STATUS_CODES of Rack::Utils
  # inverted for easier access

  STATUS_CODE = Rack::Utils::HTTP_STATUS_CODES.invert

  # This module holds all classes and methods related to the adapters like
  # webrick or mongrel.
  # It's responsible for starting and stopping them.

  module Adapter
    class << self

      # Is called by Ramaze.startup and will first call start_adapter and wait
      # up to 3 seconds for an adapter to appear.
      # It will then wait for the adapters to finish If Global.run_loose is
      # set or otherwise pass you on control which is useful for testing or IRB
      # sessions.

      def startup options = {}
        start_adapter

        Timeout.timeout(3) do
          sleep 0.01 until Global.server
        end

        Global.server.join unless Global.run_loose

      rescue SystemExit
        Ramaze.shutdown
      rescue Object => ex
        Log.error(ex)
        Ramaze.shutdown
      end

      # Takes Global.adapter and starts if test_connections is positive that a
      # connection can be made to the specified host and port.
      # If you set Global.adapter to false it won't start any but deploy a
      # dummy which is useful for testing purposes where you just send fake
      # requests to Dispatcher.

      def start_adapter
        if adapter = Global.adapter
          host, port = Global.host, Global.port

          if Global.test_connections
            test_connection(host, port)
            Log.info("Ramaze is ready to run on: #{host}:#{port}")
          end

          adapter.start(host, port)
        else # run dummy
          Global.server = Thread.new{ sleep }
          Log.warn("Seems like Global.adapter is turned off", "Continue without adapter.")
        end
      rescue LoadError => ex
        Log.warn(ex, "Continue without adapter.")
      end

      # Calls ::shutdown on all running adapters and waits up to 1 second for
      # them to finish, then goes on to kill them and exit still.

      def shutdown
        Timeout.timeout(3) do
          a = Global.server[:adapter]
          a.shutdown if a.respond_to?(:shutdown)
        end
      rescue Timeout::Error
        Global.server.kill!
        # Hard exit! because it won't be able to kill Webrick otherwise
        exit!
      end

      # Opens a TCPServer temporarily and returns true if a connection is
      # possible and false if none can be made

      def test_connection(host, port)
        Timeout.timeout(1) do
          testsock = TCPServer.new(host, port)
          testsock.close
          true
        end
      rescue => ex
        Log.error(ex)
        Log.error("Cannot open connection on #{host}:#{port}")
        Ramaze.shutdown
      end
    end
  end
end
