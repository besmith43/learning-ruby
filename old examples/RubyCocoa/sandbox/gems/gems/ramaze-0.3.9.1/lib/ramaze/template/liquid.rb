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

require 'liquid'

module Ramaze
  module Template

    # Is responsible for compiling a template using the Liquid templating engine.
    # Can be found at: http://home.leetsoft.com/liquid

    class Liquid < Template

      ENGINES[self] = %w[ liquid ]

      class << self

        # initializes the handling of a request on the controller.
        # Creates a new instances of itself and sends the action and params.
        # Also tries to render the template.
        # In Theory you can use this standalone, this has not been tested though.

        def transform action
          template = reaction_or_file(action)

          instance = action.instance
          hash     = instance.instance_variable_get("@hash") || {}
          template = ::Liquid::Template.parse(template)
          options  = instance.ancestral_trait[:liquid_options]

          template.render(hash, options)
        end
      end
    end
  end
end
