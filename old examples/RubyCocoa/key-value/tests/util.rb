#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
load '../../sandbox.rb'

require 'osx/cocoa'
include OSX

require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'test/mock-talk'
require 'assert2'
require 'stringio'
require 'fcntl'

# Ignore standard stderr for duration of block.
# Should this also handle stdout?
def silently
  stash = IO.for_fd($stderr.fcntl(Fcntl::F_DUPFD)) # also goes to stderr.
  $stderr.close   # C-level output to fid 2 now goes nowhere.
  $stderr = StringIO.new  # Ruby-level output now discarded.
  yield
ensure
  reopened_stderr = stash.fcntl(Fcntl::F_DUPFD)
  raise "Didn't reopen fd 2? #{reopened_stderr}" unless 2 == reopened_stderr
  $stderr = IO.for_fd(reopened_stderr)
end

