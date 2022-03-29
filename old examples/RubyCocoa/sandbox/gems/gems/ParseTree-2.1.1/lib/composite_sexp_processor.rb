#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'sexp_processor'

##
# Implements the Composite pattern on SexpProcessor. Need we say more?
#
# Yeah... probably. Implements a SexpProcessor of SexpProcessors so
# you can easily chain multiple to each other. At some stage we plan
# on having all of them run +process+ and but only ever output
# something when +generate+ is called, allowing for deferred final
# processing.

class CompositeSexpProcessor < SexpProcessor

  ##
  # The list o' processors to run.

  attr_reader :processors

  def initialize # :nodoc:
    super
    @processors = []
  end

  ##
  # Add a +processor+ to the list of processors to run.

  def <<(processor)
    raise ArgumentError, "Can only add sexp processors" unless
      SexpProcessor === processor
    @processors << processor
  end

  ##
  # Run +exp+ through all of the processors, returning the final
  # result.

  def process(exp)
    @processors.each do |processor|
      exp = processor.process(exp)
    end
    exp
  end

  def on_error_in(node_type, &block)
    @processors.each do |processor|
      processor.on_error_in(node_type, &block)
    end
  end
end
