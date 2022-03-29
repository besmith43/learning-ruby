#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'test/unit'
require 'flexmock'

class DummyModel
end

class ChildModel < DummyModel
end

######################################################################
class TestFlexModel < Test::Unit::TestCase
  include FlexMock::TestCase

  def test_initial_conditions
    model = flexmock(:model, DummyModel)
    assert_match(/^DummyModel_\d+/, model.flexmock_name)
    assert_equal model.id.to_s, model.to_params
    assert ! model.new_record?
    assert model.is_a?(DummyModel)
    # TODO: Make these work!!!
    assert_equal DummyModel, model.class
    assert model.instance_of?(DummyModel)
    assert model.kind_of?(DummyModel)
  end

  def test_classifying_mock_models
    model = flexmock(:model, ChildModel)

    assert model.kind_of?(ChildModel)
    assert model.instance_of?(ChildModel)

    assert model.kind_of?(DummyModel)
    assert ! model.instance_of?(DummyModel)
  end

  def test_mock_models_have_different_ids
    m1 = flexmock(:model, DummyModel)
    m2 = flexmock(:model, DummyModel)
    assert m2.id != m1.id
  end

  def test_mock_models_can_have_quick_defs
    model = flexmock(:model, DummyModel, :xyzzy => :ok)
    assert_equal :ok, model.xyzzy
  end

  def test_mock_models_can_have_blocks
    model = flexmock(:model, DummyModel) do |m|
      m.should_receive(:xyzzy => :okdokay)
    end
    assert_equal :okdokay, model.xyzzy
  end
end
