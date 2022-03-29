#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'util'
require 'stock-classes'


class KeyValueObservingTests < Test::Unit::TestCase


  CALLBACK=:observeValueForKeyPath_ofObject_change_context


  def setup
    @watcher = rubycocoa_flexmock
    @observed = ObservableValueHolder.alloc.initWithValue('original')
  end

  context "change callbacks" do 	

    should "cause a particular method to be called" do
      @observed.objc_send(:addObserver, @watcher,
                  :forKeyPath, 'value',
                  :options, nil,
                  :context, nil)
      during { 
        @observed.value = NSObject.alloc.init
      }.behold! {
        @watcher.should_receive(CALLBACK, 4).once
      }
    end

    should "include the keypath and changed object" do
      add_observer(:watcher => @watcher, :forKeyPath => 'value')   # (1) 
      during {
        @observed.value = "hello"         # (2)
      }.behold! {
        @watcher.should_receive(CALLBACK, 4).once.  # (3)
                 with('value', @observed, any, any)
      }
    end


    should "contain old and new values (if requested)" do
      add_observer(:options => NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionOld)
      during {
        @observed.value = "new"
      }.behold! {
        watcher_should_be_told(:old => 'original', :new => "new",
                               :keyPath => 'value')
      }
    end


    should "contain the initial value (if requested)" do
      during {
        add_observer(:options => NSKeyValueObservingOptionInitial |
                                 NSKeyValueObservingOptionNew)
      }.behold! {
        watcher_should_be_told(:new => 'original')
      }
    end

    should "require the New option when asking for initial value" do
      during {
        add_observer(:options => NSKeyValueObservingOptionInitial)
      }.behold! {
        watcher_should_be_told(:new => nil, :old => nil)
      }
    end

    should "be sent even if the new and old values are pointer-identical" do
      add_observer(:options => NSKeyValueObservingOptionNew)
      during {
        @observed.value = @observed.value
      }.behold! {
        watcher_should_be_told(:new => @observed.value)
      }
    end


  end

  context "setters" do

    should "include Ruby-style, Objc-style, and key-value setters" do
      add_observer
      during { 
        @observed.value = NSObject.alloc.init 
        @observed.setValue("something else")
        @observed.setValue_forKey("third setter", 'value')
      }.behold! {
        @watcher.should_receive(CALLBACK, 4).times(3)
      }
    end

  end


  context "direct setting of instance variables" do
    should "should not cause watchers to be informed. Only setters do." do
      add_observer
      during { 
        @observed.set_instance_variable_directly(8)
      }.behold! {
        # Nothing happens
      }
    end
  end

  context "rooted keypaths" do

    setup do
      @third = ObservableValueHolder.alloc.initWithValue('3')
      @second = ObservableValueHolder.alloc.initWithValue(@third)
      @observed.value = @second
    end
    
    should "notify about the /root/ even if the end of keypath changes" do
      add_observer(:forKeyPath => 'value.value.value',
                   :options => NSKeyValueObservingOptionNew)
      during {
        @third.value = 'new three'
      }.behold! {
        watcher_should_be_told(:forKeyPath => 'value.value.value',
                               :object => @observed,
                               :new => 'new three')
      }
    end

    should "notify with the value of the keypath end even if an earlier value changes" do
      add_observer(:forKeyPath => 'value.value.value',
                   :options => NSKeyValueObservingOptionNew)
      during {
        new_third = ObservableValueHolder.alloc.initWithValue('changed tail')
        new_second = ObservableValueHolder.alloc.initWithValue(new_third)
        @observed.value = new_second
      }.behold! {
        watcher_should_be_told(:forKeyPath => 'value.value.value',
                               :object => @observed,
                               :new => 'changed tail')
      }
    end
  end

  context "NSDictionaries" do
    should "trigger key-value notifications - their keys act like properties" do
      value_holder = ObservableValueHolder.alloc.initWithValue('val')
      dictionary = {'a' => value_holder}.to_ns
      @observed.value = dictionary

      add_observer(:forKeyPath => 'value.a.value',
                   :options => NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionOld)

      during { 
        dictionary['a'] = {'value' => 'changing type!' }
      }.behold! {
        watcher_should_be_told(:forKeyPath => 'value.a.value',
                               :object => @observed,
                               :old => 'val',
                               :new => 'changing type!')
      }
    end
  end




  def add_observer(hash = {})
    @observed.objc_send(:addObserver, hash.fetch(:watcher, @watcher),
                        :forKeyPath, hash.fetch(:forKeyPath, 'value'),
                        :options, hash.fetch(:options, nil),
                        :context, hash.fetch(:context, nil))
  end

  def watcher_should_be_told(expected)
    key_path = expected.fetch(:forKeyPath, 'value')
    object = expected.fetch(:object, @observed)
    @watcher.should_receive(CALLBACK, 4).
            once.
            with(key_path,
                 object,
                 on { | actuals |
                      actuals[:old] == expected[:old] &&
                      actuals[:new] == expected[:new]
                 },  
                 any)
  end


end

