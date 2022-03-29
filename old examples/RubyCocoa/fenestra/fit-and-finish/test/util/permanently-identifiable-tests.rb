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

class PermanentTestClass  < OSX::NSObject
  include PermanentlyIdentifiable

  attr_accessor :attribute

  def init
    initWithAttribute(5)
  end

  def initWithAttribute(value)
    super_init
    @attribute = value
    become_permanently_identifiable
    self
  end

  def encodeWithCoder(coder)
    coder.encodeObject_forKey(@attribute, 'attribute')
    encode_permanent_identity(coder)
  end

  def initWithCoder(coder)
    initWithAttribute(coder.decodeObjectForKey('attribute'))
    decode_permanent_identity(coder)
    self
  end

  def ==(other)
    @attribute == other.attribute
  end

end

class PermanentIdentifiableTests < Test::Unit::TestCase
  include OSX
  
  def setup
    @original = PermanentTestClass.alloc.init
    @other = PermanentTestClass.alloc.init
  end

  context "replaceability" do
    should "allow an object to replace its (pointer-equal) self" do
      assert { @original.was_originally_identically?(@original) } 
    end

    should "not necessarily be implied by equality" do
      assert { @original == @other } 
      deny { @original.was_originally_identically?(@other) }
    end

    should "not require equality if one object 'came from' the other" do
      later_pref = @original.dup
      later_pref.attribute = "some other attribute value"
      assert { later_pref.was_originally_identically?(@original) }
    end


    should "be preserved over archiving/unarchiving" do
      data = NSKeyedArchiver.archivedDataWithRootObject(@original)
      other = NSKeyedUnarchiver.unarchiveObjectWithData(data)
      assert { other.was_originally_identically?(@original) }
    end
  end

end

