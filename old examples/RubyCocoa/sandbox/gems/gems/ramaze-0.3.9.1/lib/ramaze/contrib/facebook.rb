#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require __DIR__/:facebook/:facebook

module Ramaze
  module Helper::Facebook
    def self.included(klass)
      klass.send(:helper, :aspect)
    end

    def error
      if Facebook::ADMINS.include? facebook[:user]
        error = Ramaze::Dispatcher::Error.current
        [error, *error.backtrace].join '<br/>'
      end
    end

    private

    def facebook
      @facebook ||= Facebook::Client.new
    end
    alias fb facebook
  end
end