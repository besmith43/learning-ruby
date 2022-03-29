#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'redcloth'

module Ramaze
  module Template

    # Is responsible for compiling a template using the RedCloth templating engine.
    # Can be found at: http://whytheluckystiff.net/ruby/redcloth/

    class RedCloth < Erubis
      ENGINES[self] = %w[ redcloth ]

      class << self
        def transform(action)
          restrictions = action.controller.trait[:redcloth_options] || []
          rules = action.controller.trait[:redcloth_options] || []

          # Erubis -> RedCloth -> HTML
          redcloth = ::RedCloth.new(super, restrictions)
          redcloth.to_html(*rules)
        end
      end
    end
  end
end
