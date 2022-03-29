#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require "ruby-prof"

module Ramaze
  module Dispatcher
    class ActionProfiler < Action
      def self.process(path)
        if RubyProf.running?
          super
        else
          result = RubyProf.profile { super }
          output = StringIO.new
          printer = RubyProf::FlatPrinter.new(result)
          options = {
            :min_percent => Contrib::Profiling.trait[:min_percent],
            :print_file => false
          }
          printer.print(output, options)
          output.string.split("\n").each do |line|
            Log.info(line)
          end
        end
      end
    end
  end

  module Contrib
    class Profiling
      trait :min_percent => 1

      def self.startup
        Dispatcher::FILTER.delete(Dispatcher::Action)
        Dispatcher::FILTER << Dispatcher::ActionProfiler
      end
    end
  end
end
