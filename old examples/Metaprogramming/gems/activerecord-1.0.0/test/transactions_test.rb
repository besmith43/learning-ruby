#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'abstract_unit'
require 'fixtures/topic'


class TransactionTest < Test::Unit::TestCase
  def setup
    @topics         = create_fixtures "topics"
    @first, @second = Topic.find(1, 2)
  end

  def test_succesful
    Topic.transaction do
      @first.approved  = 1
      @second.approved = 0
      @first.save
      @second.save
    end
    
    assert Topic.find(1).approved?, "First should have been approved"
    assert !Topic.find(2).approved?, "Second should have been unapproved"
  end
  
  def test_failing_on_exception
    begin
      Topic.transaction do
        @first.approved  = true
        @second.approved = false
        @first.save
        @second.save
        raise "Bad things!"
      end
    rescue
      # caught it
    end

    assert @first.approved?, "First should still be changed in the objects"
    assert !@second.approved?, "Second should still be changed in the objects"
    
    assert !Topic.find(1).approved?, "First shouldn't have been approved"
    assert Topic.find(2).approved?, "Second should still be approved"
  end
  
  def test_failing_with_object_rollback
    begin
      Topic.transaction(@first, @second) do
        @first.approved  = true
        @second.approved = false
        @first.save
        @second.save
        raise "Bad things!"
      end
    rescue
      # caught it
    end
    
    assert !@first.approved?, "First shouldn't have been approved"
    assert @second.approved?, "Second should still be approved"
  end
  
  def test_callback_rollback_in_save
    add_exception_raising_after_save_callback_to_topic

    begin
      @first.approved = true
      @first.save
      flunk
    rescue => e
      assert_equal "Make the transaction rollback", e.message
      assert !Topic.find(1).approved?
    ensure
      remove_exception_raising_after_save_callback_to_topic
    end
  end

  private
    def add_exception_raising_after_save_callback_to_topic
      Topic.class_eval { def after_save() raise "Make the transaction rollback" end }
    end
    
    def remove_exception_raising_after_save_callback_to_topic
      Topic.class_eval { remove_method :after_save }
    end
end