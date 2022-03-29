#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Bacon
  module PrettyOutput
    NAME = ''

    def handle_specification(name)
      NAME.replace name
			puts NAME
      yield
			puts
    end

    def handle_requirement(description)
	    print "- #{description}\n"
      error = yield

      unless error.empty?
        if defined?(Ramaze::Logging)
          puts '', " #{NAME} -- #{description} [FAILED]".center(70, '-'), ''
          colors = Ramaze::Informer::COLORS

          until RamazeLogger.history.empty?
            tag, line = RamazeLogger.history.shift
            out = "%6s | %s" % [tag.to_s, line]
            puts out.send(colors[tag])
          end
        end

        general_error
      end
    end

    def general_error
      puts "", ErrorLog
      ErrorLog.scan(/^\s*(.*?):(\d+): #{NAME} - (.*?)$/) do
        puts "#{ENV['EDITOR'] || 'vim'} #$1 +#$2 # #$3"
      end
      ErrorLog.replace ''
    end

    def handle_summary
	    puts
      puts "%d tests, %d assertions, %d failures, %d errors" %
        Counter.values_at(:specifications, :requirements, :failed, :errors)
    end
  end
end

if defined?(Ramaze::Logging)
  module Ramaze
    class SpecLogger
      include Ramaze::Logging
      include Enumerable

      attr_accessor :history

      def initialize
        @history = []
      end

      def each
        @history.each{|e| yield(e) }
      end

      def log(tag, str)
        @history << [tag, str]
      end
    end
  end

  module Bacon::PrettyOutput
    RamazeLogger = Ramaze::SpecLogger.new
    Ramaze::Log.loggers = [RamazeLogger]
  end
end
