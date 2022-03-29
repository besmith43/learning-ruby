#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Rack
  module Auth
    # Rack::Auth::AbstractHandler implements common authentication functionality.
    #
    # +realm+ should be set for all handlers.

    class AbstractHandler

      attr_accessor :realm

      def initialize(app, &authenticator)
        @app, @authenticator = app, authenticator
      end


      private

      def unauthorized(www_authenticate = challenge)
        return [ 401, { 'WWW-Authenticate' => www_authenticate.to_s }, [] ]
      end

      def bad_request
        [ 400, {}, [] ]
      end

    end
  end
end
