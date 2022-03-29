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

require 'tagz'

module Ramaze

  # Allows you to use some shortcuts for Tagz in your Controller.

  # use this inside your controller to directly build Tagz
  # Refer to the Tagz-documentation and testsuite for more examples.
  # Usage:
  #   tagz { h1_{ "Apples & Oranges" } }                   #=> "<h1>Apples &amp; Oranges</h1>"
  #   tagz { h1_(:class => 'fruits&floots'){ 'Apples' } }  #=> "<h1 class=\"fruits&amp;floots\">Apples</h1>"

  module Helper
    Tagz = ::Tagz
  end
end
