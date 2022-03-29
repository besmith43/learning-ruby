#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")
require File.dirname(__FILE__) + "/testutil"

class TranslatorPreferenceTests < Test::Unit::TestCase
  include OSX

  def setup
    @pref = TranslatorPreference.alloc.init
    @other = TranslatorPreference.alloc.init
  end

  context "initialization" do
    should "set source to the empty string" do
      assert { @pref.source == '' }
    end
  end

  context "favorite value" do
    should "be true when set to cocoa-boolean true" do
      @pref.favorite = true.to_ns
      assert { true == @pref.favorite }
    end
    should "be true when set to ruby true" do
      @pref.favorite = true
      assert { true == @pref.favorite }
    end
    should "be false when set to cocoa-boolean false" do
      @pref.favorite = false.to_ns
      assert { false == @pref.favorite }
    end
    should "be false when set to ruby false" do
      @pref.favorite = false
      assert { false == @pref.favorite }
    end
  end

    
  ['==', 'isEqual'].each do | variant | 

    context "equality (#{variant})" do
      should "be implied by pointer-equality" do
        assert { @pref.send(variant, @pref) } 
      end

      should "be field-wise" do
        assert { @pref.send(variant, @other) }
      end

      should "be falsified by a field change" do
        @other.source = 'm'
        deny { @pref.send(variant, @other) } 
      end

      should "not be fooled by a cocoa-true (1) value" do
        @pref.favorite = true
        @other.favorite = true.to_ns
        assert { @pref.send(variant, @other) } 
      end
      
      should "not be fooled by a cocoa-false (0) value" do
        @pref.favorite = false
        @other.favorite = false.to_ns
        assert { @pref.send(variant, @other) } 
      end
      
    end
  end

  context "permanent identity" do
    should "be achieved by proper use of module methods" do
      assert { @pref.was_originally_identically?(@pref.dup) } 
      assert { @pref == @other }
      deny { @pref.was_originally_identically?(@other) }
    end
  end

  context "hash" do
    should "be implied by is_equal" do
      assert { @pref.hash == @other.hash } 
    end

    should "not change if any field changes" do 
      # We'll take responsibility for ensuring that a 
      # change to an object used as a key in a hash table 
      # doesn't cause object to be "lost".
      orig_hash = @pref.hash
      TranslatorPreference::Properties.each do | prop |
        @pref.send(prop.to_s+'=', 12343532)
      end
      assert { orig_hash == @pref.hash }
    end
        
  end
      
end

