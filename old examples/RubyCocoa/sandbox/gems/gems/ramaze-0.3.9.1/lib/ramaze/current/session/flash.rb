#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Ramaze
  class Session
    # The purpose of this class is to act as a unifier of the previous
    # and current flash.
    #
    # Flash means pairs of keys and values that are held only over one
    # request/response cycle. So you can assign a key/value in the current
    # session and retrieve it in the current and following request.
    #
    # Please see the FlashHelper for details on the usage as you won't need
    # to touch this class at all.
    class Flash
      include Enumerable
      def each(&block)
        combined.each(&block)
      end

      # the current session[:FLASH_PREVIOUS]
      def previous
        session[:FLASH_PREVIOUS] || {}
      end

      # the current session[:FLASH]
      def current
        session[:FLASH] ||= {}
      end

      # combined key/value pairs of previous and current
      # current keys overshadow the old ones.
      def combined
        previous.merge(current)
      end

      # flash[key] in your Controller
      def [](key)
        combined[key]
      end

      # flash[key] = value in your Controller
      def []=(key, value)
        prev = session[:FLASH] || {}
        prev[key] = value
        session[:FLASH] = prev
      end

      # Inspects the combined SessionFlash

      def inspect
        combined.inspect
      end

      # Delete a key

      def delete(key)
        current.delete(key)
      end

      private

      # Session.current or {}

      def session
        Current.session || {}
      end
    end
  end
end
