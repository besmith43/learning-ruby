#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'stringio'

# Mix-in for capturing standard output.
module CaptureStdout
  def capture_stdout
    s = StringIO.new
    oldstdout = $stdout
    $stdout = s
    yield
    s.string
  ensure
    $stdout = oldstdout
  end

  def capture_stderr
    s = StringIO.new
    oldstderr = $stderr
    $stderr = s
    yield
    s.string
  ensure
    $stderr = oldstderr
  end
end
