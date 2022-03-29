#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Ramaze
  module Helper
    module User
      def self.inherited(klass)
        klass.trait :user_model => ::User
      end

      def user
        if instance_variable_defined?('@user_helper')
          @user_helper
        else
          @user_helper = Wrapper.new ancestral_trait[:user_model]
        end
      end

      class Wrapper
        thread_accessor :session
        attr_accessor :user

        def initialize(model)
          raise ArgumentError, "No model defined for Helper::User" unless model
          @model = model
          @user = nil
          login(persist)
        end

        def logged_in?
          !!@user
        end

        def login?(hash)
          credentials = {}
          hash.each{|k,v| credentials[k.to_sym] = v.to_s }
          @model[credentials]
        end

        def persist
          session[:USER] ||= {}
        end

        def persist=(hash)
          session[:USER] = hash
        end

        def login(hash = Request.current.params)
          return if hash.empty?
          if found = login?(hash)
            @user = found
            self.persist = hash
          end
        end

        def logout
          persist.clear
        end

        def method_missing(meth, *args, &block)
          @user.send(meth, *args, &block)
        end
      end
    end
  end
end
