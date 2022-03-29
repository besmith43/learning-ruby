#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'builder'

module Ramaze
  module Template

      class Builder < Template
        ENGINES[self] = %w[ builder rxml ]

        class << self
          def transform action
            if response = Response.current
              response['Content-Type'] = "application/xml"
            end

            template = wrap_compile(action)
            action.instance.instance_eval(template, action.template || __FILE__)
          end

          def compile action, template
            "xml = ::Builder::XmlMarkup.new(:indent => 2)\n" +
            template +
            "\nxml.target!\n"
          end
        end
      end

  end
end