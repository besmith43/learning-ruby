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

require 'haml/engine'

module Ramaze
  module Template

    # Is responsible for compiling a template using the Haml templating engine.
    # Can be found at: http://haml.hamptoncatlin.com/

    class Haml < Template

      ENGINES[self] = %w[ haml ]

      class << self

        # Transform via Haml templating engine

        def transform action
          haml = wrap_compile(action)
          haml.to_html(action.instance, action.binding.locals)
        end

        # Instantiates Haml::Engine with the template and haml_options trait from
        # the controller.

        def compile(action, template)
          opts = action.controller.trait[:haml_options] || {}
          opts.merge! :filename => action.template if action.template

          ::Haml::Engine.new(template, opts)
        end
      end
    end
  end
end
