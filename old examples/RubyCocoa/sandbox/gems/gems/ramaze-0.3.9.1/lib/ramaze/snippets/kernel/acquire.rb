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

# Extensions for Kernel

module Kernel

  # Require all .rb and .so files on the given globs, utilizes Dir::[].
  #
  # Examples:
  #   # Given following directory structure:
  #   # src/foo.rb
  #   # src/bar.so
  #   # src/foo.yaml
  #   # src/foobar/baz.rb
  #   # src/foobar/README
  #
  #   # requires all files in 'src':
  #   acquire 'src/*'
  #
  #   # requires all files in 'src' recursive:
  #   acquire 'src/**/*'
  #
  #   # require 'src/foo.rb' and 'src/bar.so' and 'src/foobar/baz.rb'
  #   acquire 'src/*', 'src/foobar/*'

  def acquire *globs
    globs.flatten.each do |glob|
      Dir[glob].each do |file|
        require file if file =~ /\.(rb|so)$/
      end
    end
  end

  def aquire *globs
    warn "Kernel#aquire is being deprecated, use Kernel#acquire instead"
    acquire *globs
  end
end
