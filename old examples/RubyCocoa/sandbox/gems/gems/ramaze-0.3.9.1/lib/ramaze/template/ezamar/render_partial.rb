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

require 'ramaze/template/ezamar/engine'
require 'ramaze/helper/partial'

module Ezamar

  # A transformer for <render /> tags.

  class RenderPartial
    extend Ramaze::Helper::Partial

    # Renders <render src="/path" [optional="option", ...]> in place.
    #
    # Other options than `src` will be transformed to session parameters for the
    # rendered action to use.

    def self.transform(template)
      template.gsub!(/<render (.*?) \/>/) do |m|
        args = Hash[*$1.scan(/(\S+)=["'](.*?)["']/).flatten]
        if src = args.delete('src')
          render_partial(src, args)
        end
      end

      template
    end

  end
end
