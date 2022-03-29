#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Translator'

module Translators
  class ToString < Translator

    on_remote_notification(nil, lambda { @app }) do | notification |
      translate_as notification.to_s
    end
  end
end
