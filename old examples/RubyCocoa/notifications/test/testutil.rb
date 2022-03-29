#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require '../../sandbox'
$: << "../lib"

require 'osx/cocoa'
include OSX

require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'test/mock-talk'

require 'test/notification-utils'
