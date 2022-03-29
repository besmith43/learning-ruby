#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../../sandbox")
require 'testutil'


class MockTalkTests < Test::Unit::TestCase
  context "Mockable" do
    should "produce a subclass of the given class" do
      assert { Mockable(NSDictionary).superclass == NSDictionary } 
    end

    should "produce a class that defines methods with name and arity" do
      mock = Mockable(NSObject).alloc.init
      mock.define_method_to_be_mocked(:foo, 3)
      assert { mock.class.instance_method(:foo) }
      assert { mock.class.instance_method(:foo).arity == 3 }
    end

    should "define a method that is never meant to be called" do
      mock = Mockable(NSObject).alloc.init
      mock.define_method_to_be_mocked(:foo, 3)
      assert_raise_message(RuntimeError, /supposed.*mock/) {
        mock.foo(1, 2, 3)
      }
    end
  end

  context "rubycocoa_flexmock" do
    should "produce an NSObject subclass if given no arguments" do
      mock = rubycocoa_flexmock
      assert { mock.class.superclass == NSObject } 
    end

    # Unclear that this is useful.
    should "take should_receive with normal arg and define no instance method" do
      mock = rubycocoa_flexmock
      mock.should_receive(:foo).once.with(1, 2, 3)
      assert_raise_message(NameError,  /undefined method/) {
        mock.class.instance_method(:ordinary_mock_method)
      }

      # Works, too.
      mock.foo(1, 2, 3)
    end


    should "use a special form of should_receive that defines a class instance method" do 
      mock = rubycocoa_flexmock

      mock.should_receive(:instance_mock_method, 1).once.with(1)
      mock.should_receive(:zero_args, 0).once.with_no_args

      assert { mock.class.instance_method(:instance_mock_method) } 
      assert { mock.class.instance_method(:zero_args) } 

      # They work, too.
      mock.instance_mock_method(1)
      mock.zero_args
    end

    # NOTE: many classes, like NSDictionary and NSString, require subclasses to
    # define primitive methods.

    should "produce something other than an NSObject subclass if given single class argument" do
      mock = rubycocoa_flexmock(NSButton)
      assert { mock.class.superclass == NSButton } 
      assert { mock.state == NSOffState }

      during { 
        mock.performKeyEquivalent(nil)
      }.behold! {
        mock.should_receive(:performKeyEquivalent).once.with(nil)
      }
    end


    should "take a block to do object creation and initialization" do
      mock = rubycocoa_flexmock(NSNotificationCenter) do | klass |
        klass.defaultCenter
      end

      during { 
        mock.postNotificationName_object('name', 'object') 
      }.behold! {
        mock.should_receive(:postNotificationName_object).once.
             with('name', 'object')
      }
    end

    should "be able to take a mock's name as first argument" do
      mock = rubycocoa_flexmock("fred")
      assert { mock.class.superclass == NSObject }
      assert { mock.flexmock_get.flexmock_name == "fred" } 
    end

    should "be able to take a mock's name as second argument" do 
      mock = rubycocoa_flexmock(NSDictionary, "fred")
      assert { mock.class.superclass == NSDictionary }
      assert { mock.flexmock_get.flexmock_name == "fred" } 
    end


  end
end

