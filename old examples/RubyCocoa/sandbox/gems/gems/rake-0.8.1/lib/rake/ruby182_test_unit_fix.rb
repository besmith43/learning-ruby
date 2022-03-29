#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Test
  module Unit
    module Collector
      class Dir
        undef collect_file
        def collect_file(name, suites, already_gathered)
          # loadpath = $:.dup
          dir = File.dirname(File.expand_path(name))
          $:.unshift(dir) unless $:.first == dir
          if(@req)
            @req.require(name)
          else
            require(name)
          end
          find_test_cases(already_gathered).each{|t| add_suite(suites, t.suite)}
        ensure
          # $:.replace(loadpath)
          $:.delete_at $:.rindex(dir)
        end
      end
    end
  end
end
