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

require 'amrita2'

class Amrita2::Template

  # Ramaze helpers are available in template contexts.

  include Ramaze::Helper::Methods
  helper :link, :sendfile, :flash, :cgi
end

module Ramaze
  module Template

    # Is responsible for compiling a template using the Amrita2 templating engine.
    # Can be found at: http://rubyforge.org/projects/amrita2

    class Amrita2 < Template

      ENGINES[self] = %w[ amrita amr a2html ]

      class << self

        # Takes an Action
        # The result or file is rendered using Amrita2::Template.
        #
        # The context data are set to @data in the controller before expansion.

        def transform(action)
          template = wrap_compile(action)
          data = action.instance.instance_variable_get("@data") || {}
          action.instance.extend ::Amrita2::Runtime if data.kind_of? Binding
          template.render_with(data)
        end

        def compile(action, template)
          ::Amrita2::Template.new(template)
        end
      end
    end
  end
end
