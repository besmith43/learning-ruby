#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

module Rake

  # Makefile loader to be used with the import file loader.
  class MakefileLoader

    # Load the makefile dependencies in +fn+.
    def load(fn)
      buffer = ''
      open(fn) do |mf|
        mf.each do |line|
          next if line =~ /^\s*#/
          buffer << line
          if buffer =~ /\\$/
            buffer.sub!(/\\\n/, ' ')
            state = :append
          else
            process_line(buffer)
            buffer = ''
          end
        end
      end
      process_line(buffer) if buffer != ''
    end

    private

    # Process one logical line of makefile data.
    def process_line(line)
      file_task, args = line.split(':')
      return if args.nil?
      dependents = args.split
      file file_task => dependents
    end
  end

  # Install the handler
  Rake.application.add_loader('mf', MakefileLoader.new)
end
