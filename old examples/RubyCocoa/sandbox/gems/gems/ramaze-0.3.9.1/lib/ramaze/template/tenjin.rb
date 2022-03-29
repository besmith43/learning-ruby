#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require "tenjin"
require "tempfile"

class Tenjin::Context
  include Ramaze::Helper::Methods
  helper :link, :sendfile, :flash, :cgi
end

module Ramaze
  module Template

    # Is responsible for compiling a template using the Tenjin templating engine.
    # Can be found at: http://www.kuwata-lab.com/tenjin/

    class Tenjin < Template

      ENGINES[self] = %w[ rbhtml tenjin ]

      class << self
        def transform(action)
          tenjin = wrap_compile(action)
          context = action.instance.instance_variable_get("@context") || {}
          tenjin.render(context)
        end

        def compile(action, template)
          tenjin = ::Tenjin::Template.new
          tenjin.convert(template)
          return tenjin
        end
      end
    end
  end
end
