#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/unit'
require File.dirname(__FILE__) + '/ruby_reflector'

#  FIXME  evaluate parts[3]
#  ERGO  if the block is a block, decorate with do-end
#  ERGO  decorate assert_latest's block at fault time


# BEM: Patch to prevent colorization in Emacs shell buffer. Submitted.
module RubyNodeReflector::Coulor
 alias_method 'old_colorize?', 'colorize?'

 def colorize?
   return false if ENV['EMACS']=='t'
   old_colorize?
 end
end


module Assert_2_0
  include RubyNodeReflector
  include Coulor #:nodoc:

  #  This assertion calls a block, and faults if this returns
  #  +false+ or +nil+. The fault diagnostic will reflect the
  #  intermediate value of every variable and expression in the
  #  block.
  #
  #  The first argument can be a diagnostic string:
  #
  #    assert("foo failed"){ foo() }
  #
  #  The fault diagnostic will print that line.
  # 
  #  The next time you think to write any of these assertions...
  #  
  #  - +assert+
  #  - +assert_equal+
  #  - +assert_instance_of+
  #  - +assert_kind_of+
  #  - +assert_operator+
  #  - +assert_match+
  #  - +assert_not_nil+
  #  
  #  use <code>assert{ 2.0 }</code> instead.
  #
  #  If no block is provided, the assertion calls +assert_classic+,
  #  which simulates RubyUnit's standard <code>assert()</code>.
  #  
  #  Note: This only works for Ruby 1.8.6 so far...
  #
  def assert(*args, &block)
    if block
      assert_ args.first, '', &block
    else
      assert_classic *args
    end
  end

  #  The new <code>assert()</code> calls this to interpret
  #  blocks of assertive statements.
  #
  def assert_(diagnostic = nil, twizzler = '_', &block)
      # puts reflect(&block) # activate this line and test to see all your successes!
      result = nil
      
      begin
	result = block.call
      rescue => e
        diagnostic = [diagnostic, e.inspect, *e.backtrace].compact.join("\n\t")
       _flunk_2_0("\nassert#{ twizzler }{ ", diagnostic, block, result)
      end
      
      return if result
     _flunk_2_0("assert#{ twizzler }{ ", diagnostic, block, result)
  end

  #  This assertion replaces:
  #  
  #  - +assert_nil+
  #  - +assert_no_match+
  #  - +assert_not_equal+
  #
  #  It faults, and prints its block's contents and values,
  #  if its block returns non-+false+ and non-+nil+.
  #  
  def deny(diagnostic = nil, &block)  
      #  "None shall pass!" --the Black Knight
      # puts reflect(&block) # activate this line and test to see all your denials!
    result = nil
    
    begin
      result = block.call
    rescue => e
      diagnostic = [diagnostic, e.inspect, *e.backtrace].compact.join("\n\t")
     _flunk_2_0("\ndeny{ ", diagnostic, block, result)
    end
    
    return unless result
   _flunk_2_0('deny{ ', diagnostic, block, result)
  end  #  "You're a looney!"  -- King Arthur

  # Assert that a block raises a given Exception type matching 
  # a given message
  # 
  # * +types+ - single exception class or array of classes
  # * +matcher+ - Regular Expression to match the inner_text of XML nodes
  # * +diagnostic+ - optional string to add to failure message
  # * +block+ - Ruby statements that should raise an exception
  #
  # Examples:
  # %transclude AssertXPathSuite#test_assert_raise_message_detects_assertion_failure
  #
  # %transclude AssertXPathSuite#test_assert_raise_message_raises_message
  #
  # See: {assert_raise - Don't Just Say "No"}[http://www.oreillynet.com/onlamp/blog/2007/07/assert_raise_on_ruby_dont_just.html]
  #
  def assert_raise_message(types, matcher, diagnostic = nil, &block)
    args = [types].flatten + [diagnostic]
    exception = assert_raise(*args, &block)
    
    assert_match matcher,
                 exception.message,
                 [ diagnostic, 
                   "incorrect #{ exception.class.name 
                     } message raised from block:", 
                   "\t"+reflect_source(&block).split("\n").join("\n\t")
                   ].compact.join("\n")
    
    return exception
  end

  def deny_raise_message(types, matcher, diagnostic = nil, &block) #:nodoc:
    exception = assert_raise_message(types, //, diagnostic, &block)
    
    assert_no_match matcher,
                 exception.message,
                 [ diagnostic, 
                   "exception #{ exception.class.name 
                     } with this message should not raise from block:", 
                   "\t"+reflect_source(&block).split("\n").join("\n\t")
                   ].compact.join("\n")
    
    return exception.message
  end

  def assert_flunked(gripe, diagnostic = nil, &block) #:nodoc:
    assert_raise_message Test::Unit::AssertionFailedError,
                         gripe,
                         diagnostic,
                        &block
  end

  def deny_flunked(gripe, diagnostic = nil, &block) #:nodoc:
    deny_raise_message Test::Unit::AssertionFailedError,
                       gripe,
                       diagnostic,
                      &block
  end  #  ERGO  move to assert{ 2.0 }, reflect, and leave there!

  # This is a copy of the classic assert, so your pre�xisting
  # +assert+ calls will not change their behavior
  #
  def assert_classic(boolean, message=nil)
    _wrap_assertion do
      assert_block("assert<classic> should not be called with a block.") { !block_given? }
      assert_block(build_message(message, "<?> is not true.", boolean)) { boolean }
    end
  end
  
  #  wrap this common idiom:
  #    foo = assemble()
  #    deny{ foo.bar() }
  #    foo.activate()
  #    assert{ foo.bar() }
  #
  #  that becomes:
  #    foo = assemble()
  #
  #    assert_yin_yang proc{ foo.bar() } do
  #      foo.activate()
  #    end
  #
  def assert_yin_yang(*args, &block)
      # prock, diagnostic = nil, &block)
    procks, diagnostic = args.partition{|p| p.respond_to? :call }
    block ||= procks.shift
    source = reflect_source(&block)
    fuss = [diagnostic, "fault before calling:", source].compact.join("\n")
    procks.each do |prock|  deny(fuss, &prock);  end
    block.call
    fuss = [diagnostic, "fault after calling:", source].compact.join("\n")
    procks.each do |prock|  assert(fuss, &prock);  end
  end

  #  the prock assertion must pass on both sides of the called block
  #
  def deny_yin_yang(prock, diagnostic = nil, &block)
    source = reflect_source(&block)
    fuss = [diagnostic, "fault before calling:", source].compact.join("\n")
    assert fuss, &prock
    block.call
    fuss = [diagnostic, "fault after calling:", source].compact.join("\n")
    assert fuss, &prock
  end

  private
    def build_message_(diagnostic, reflection)
      diagnostic = nil if diagnostic == ''
      return [diagnostic, reflection].compact.join("\n")
    end

    def _flunk_2_0(polarity, diagnostic, block, result)
      rf = RubyReflector.new(block)
      effect = " - should #{ 'not ' if polarity =~ /deny/ }pass\n"

      report = magenta(polarity) + bold(rf.result) + magenta(" }") + 
                red(arrow_result(result) + effect) + 
                rf.format_evaluations
              
      flunk build_message_(diagnostic, report)
    end
  
end  #  "Eagle-eyes it!"

class Test::Unit::TestCase #:nodoc:
  include Assert_2_0
end
