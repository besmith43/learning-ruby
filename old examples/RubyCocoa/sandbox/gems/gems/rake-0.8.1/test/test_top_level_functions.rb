#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

begin
  require 'rubygems'
rescue LoadError
  # got no gems
end

require 'test/unit'
require 'test/capture_stdout'
require 'rake'
require 'flexmock/test_unit'

class TestTopLevelFunctions < Test::Unit::TestCase
  include CaptureStdout

  def setup
    super
    @app = Rake.application
    Rake.application = flexmock("app")
  end

  def teardown
    Rake.application = @app
    super
  end

  def test_namespace
    Rake.application.should_receive(:in_namespace).with("xyz", any).once
    namespace "xyz" do end
  end

  def test_import
    Rake.application.should_receive(:add_import).with("x").once.ordered
    Rake.application.should_receive(:add_import).with("y").once.ordered
    Rake.application.should_receive(:add_import).with("z").once.ordered
    import('x', 'y', 'z')
  end

  def test_when_writing
    out = capture_stdout do
      when_writing("NOTWRITING") do
        puts "WRITING"
      end
    end
    assert_equal "WRITING\n", out
  end

  def test_when_not_writing
    RakeFileUtils.nowrite_flag = true
    out = capture_stdout do
      when_writing("NOTWRITING") do
        puts "WRITING"
      end
    end
    assert_equal "DRYRUN: NOTWRITING\n", out
  ensure
    RakeFileUtils.nowrite_flag = false
  end

  def test_missing_constants_task
    Rake.application.should_receive(:const_warning).with(:Task).once
    Object.const_missing(:Task)
  end

  def test_missing_constants_file_task
    Rake.application.should_receive(:const_warning).with(:FileTask).once
    Object.const_missing(:FileTask)
  end

  def test_missing_constants_file_creation_task
    Rake.application.should_receive(:const_warning).with(:FileCreationTask).once
    Object.const_missing(:FileCreationTask)
  end

  def test_missing_constants_rake_app
    Rake.application.should_receive(:const_warning).with(:RakeApp).once
    Object.const_missing(:RakeApp)
  end

  def test_missing_other_constant
    assert_raise(NameError) do Object.const_missing(:Xyz) end
  end
end
