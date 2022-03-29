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

require 'sass/engine'

module Ramaze
  module Template

    # Is responsible for compiling a template using the Sass CSS templating engine.
    # Can be found at: http://haml.hamptoncatlin.com/

    class Sass < Template

      ENGINES[self] = %w[ sass ]

      class << self

        # Transform via Sass templating engine

        def transform action
          if response = Response.current
            response['Content-Type'] = "text/css"
          end
          sass = wrap_compile(action)
          sass.to_css()
        end

        # Instantiates Sass::Engine with the template and sass_options trait from
        # the controller.

        def compile(action, template)
          ::Sass::Engine.new(template, action.controller.trait[:sass_options] || {})
        end
      end
    end
  end
end
