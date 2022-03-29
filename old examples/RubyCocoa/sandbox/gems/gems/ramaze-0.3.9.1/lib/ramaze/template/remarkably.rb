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

require 'remarkably/engines/html'

module Ramaze
  module Template

    # Is responsible for compiling a template using the Remarkably templating engine.
    # Can be found at: http://rubyforge.org/projects/remarkably

    class Remarkably < Template
      ENGINES[self] = %w[ rem ]

      class << self

        # Entry point for Action#render

        def transform action
          result, file = result_and_file(action)

          result = transform_string(file, action) if file
          result.to_s
        end

        # Takes a string and action, sets args to action.args and then proceeds
        # to instance_eval the string inside the action.instance

        def transform_string(string, action)
          action.instance.instance_eval do
            args = action.params
            instance_eval(string)
          end
        end
      end
    end
  end
end
