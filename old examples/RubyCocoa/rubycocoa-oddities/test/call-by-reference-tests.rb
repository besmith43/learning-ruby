#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'testutil'
require 'CallByReference'

# Before reading these tests, look at CallByReference.m to see the 
# Objective-C code that these methods call.
# The more interesting tests have comments highlighting them.

class CallByReferenceTests < Test::Unit::TestCase
  def setup
    @sut = CallByReference.alloc.init
  end

  # Call-by-reference arguments are omitted from the argument
  # list. They are returned as extra return values.  This method
  # returns an Objective-C boolean (0 or 1) plus the string that's put
  # in the by-reference argument.
  should "be able to follow by-value argument with by-reference argument" do 
    assert { @sut.putString_inResult('retval') == [1, "retval"] }
  end

  # If there is a "slot" in the argument list for a by-reference argument, 
  # but the caller doesn't want any such return value, it can pass in a 
  # nil. A typical use is to signal that the caller is uninterested in 
  # getting a string that describes the error. It is the called method's
  # responsibility to check for nil.
  should "be able to pass nil reference argument" do 
    assert { @sut.putString_inResult('retval', nil) == 0 }
  end

  # When the method being called is void, the returned list
  # contains nothing for it. There are only the by-reference arguments. 
  should "be able to follow value arg with N by-reference arguments" do
    in_arg = 'retval'
    assert { @sut.putString_inFirstResult_andSecondResult(in_arg) == 
             [in_arg, in_arg] }
  end


  ## Underscore-format RubyCocoa syntax

  should "be able to interleave by-value and by-ref arguments" do
    result = @sut.fillResult_withObject_andFill_with('1', '2')
    assert { [1, '1', '2'] == result}
  end

  should "be able to mix nils and by-value argument" do
    result = @sut.fillResult_withObject_andFill_with(nil, '1', '2')
    assert { [1, '2'] == result}
  end

  should "be able to mix nils and by-value arguments another way" do
    result = @sut.fillResult_withObject_andFill_with('1', nil, '2')
    assert { [1, '1'] == result}
  end

  # Note that the return value is not an array. You can imagine
  # the implementation of returning multiple values looks like the 
  # following Ruby method.
  should "be able to use all nils" do
    result = @sut.fillResult_withObject_andFill_with(nil, '1', nil, '2')
    assert { 1 == result}
  end

  def return_multiple_unless_nil(control = 'fill in by-ref value')
    if control.nil?
      return 1
    else
      return 1, control
    end
  end

  should "use return_multiple_unless_nil as a model" do 
    assert { [1, 'fill in by-ref value'] == return_multiple_unless_nil }
  end


  should "get a single value on non-multiple returns" do
    assert { 1 == return_multiple_unless_nil(nil) }
  end


  # Does the following call mean the first by-reference argument
  # should be filled with nil and the second not filled? Or vice
  # versa? There's no way to tell, so RubyCocoa will raise an
  # ArgumentError exception.
  should "fail in the face of ambiguity" do
    assert_raise(ArgumentError) do 
      @sut.fillResult_withObject_andFill_with(nil, nil, nil)
    end
  end



  ## Using objc_send

  # In the alternate syntax, omitted arguments are indicated by 
  # collapsing the surrounding keywords into a single colon-separated 
  # keyword.
  should "be able to put by-ref args in any order (alt. syntax)" do
    result = @sut.objc_send('fillResult:withObject', '1',
                            'andFill:with', '2')
    assert { [1, '1', '2'] == result}
  end

  should "be able to mix nils and actual parameters another way  (alt. syntax)" do
    result = @sut.objc_send('fillResult:withObject', '1',
                            :andFill, nil,
                            :with, '2')
    assert { [1, '1'] == result}
  end

  should "be able to mix nils and actual parameters (alt. syntax)" do
    result = @sut.objc_send(:fillResult, nil,
                            :withObject, '1',
                            'andFill:with', '2')
    assert { [1, '2'] == result}
  end


  should "be able to use all nils (alt. syntax)" do
    result = @sut.objc_send(:fillResult, nil, 
                            :withObject, '1',
                            :andFill, nil,
                            :with, '2')
    assert { 1 == result}
  end

  #     It's important to understand that this alternate format is not
  #     processed differently. objc_send
  #     concatenates its odd-numbered arguments into a single method
  #     name and tries to pass it the even-numbered arguments. Even
  #     though the following looks unambiguous, it will raise a
  #     ArgumentError exception:
  should "not have ambiguity problems, but it does" do
    assert_raise(ArgumentError) do
      @sut.objc_send('fillResult:withObject', nil,
                     :andFill, nil,
                     :with, nil)
    end
  end

  # The alternate format can make it easier to confuse yourself.  In
  # the following, what I meant to say is "put nil into the first
  # by-reference argument and ignore the second." That is, I was
  # thinking of the interpretation shown in
  # fig.one.interpretation.pdf.
  # 
  # RubyCocoa's algorithm, though, loses sight of which argument was
  # attached to which keyword and instead interprets it as shown in 
  # fig.another.interpretation.pdf

  should "not lead to surprises - but it can:" do
    result = @sut.objc_send('fillResult:withObject', nil,
                            :andFill, nil,
                            :with, '1')
    # Naively, I would have expected this:
    #    assert { [1, nil] == result }
    # but it's this:
    assert { [1, '1'] == result }
  end

  should "get return value of nil when callee doesn't set ref var" do
    result = @sut.objc_send('fillResult:withString', 'result',
                            :when, false)
    assert { [0, nil] == result }
  end

end
