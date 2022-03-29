#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "erb"

def display_time
  time = Time.now.strftime("%T")
  template = "The time now is <%= time %>"

  renderer = ERB.new(template)
  puts renderer.result
end

display_time
# ~> (erb):1:in `<main>': undefined local variable or method `time'
#         for main:Object (NameError)
# ~>   from .../ruby-2.2.2/lib/ruby/2.2.0/erb.rb:863:in `eval'
# ~>   from .../ruby-2.2.2/lib/ruby/2.2.0/erb.rb:863:in `result'
# ~>   from -:8:in `display_time'
# ~>   from -:11:in `<main>'
