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

require 'swiftcore/Analogger/Client'

module Ramaze

  # Informer for the Swiftcore Analogger logging system.
  #
  # You can find it at http://analogger.swiftcore.org and install with
  # gem install analogger

  class Analogger < ::Swiftcore::Analogger::Client
    include Logging

    # identifier for your application
    trait :name => 'walrus'

    # Host analogger runs on
    trait :host => '127.0.0.1'

    # Port analogger runs on
    trait :port => 6766

    # Create a new instance, parameters default to the traits.

    def initialize(name = class_trait[:name], host = class_trait[:host], port = class_trait[:port])
      super
    end

    # integration to Logging

    def log(tag, *args)
      log(tag, args.join("\n"))
    end
  end
end
