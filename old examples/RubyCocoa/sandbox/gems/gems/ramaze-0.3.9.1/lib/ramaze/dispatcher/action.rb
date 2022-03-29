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
  module Dispatcher

    # This dispatcher is responsible for relaying requests to Controller::handle
    # and filtering the results using FILTER.

    class Action

      # The response is passed to each filter by sending .call(response) to it.

      FILTER = OrderedSet.new(
        # Ramaze::Tool::Localize,
      ) unless defined?(FILTER)

      class << self
        include Trinity

        # Takes path, asks Controller to handle it and builds a response on
        # success. The response is then passed to each member of FILTER for
        # post-processing.

        def process(path)
          Log.info("Dynamic request from #{request.ip}: #{request.request_uri}")

          catch(:respond) {
            body = Controller.handle(path)
            response = Response.current.build(body)
          }
          FILTER.each{|f| f.call(response)}
          response
        rescue Ramaze::Error => ex
          ex
        end
      end
    end
  end
end
