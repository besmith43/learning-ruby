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
require 'rake/testtask'

class TestTestTask < Test::Unit::TestCase
  include Rake
  def setup
    Task.clear
    ENV.delete('TEST')
  end

  def teardown
    FileUtils.rm_rf("testdata")
  end

  def test_no_task
    assert ! Task.task_defined?(:test)
  end

  def test_defaults
    tt = Rake::TestTask.new do |t| end
    assert_not_nil tt
    assert_equal :test, tt.name
    assert_equal ['lib'], tt.libs
    assert_equal 'test/test*.rb', tt.pattern
    assert_equal false, tt.verbose
    assert Task.task_defined?(:test)
  end

  def test_non_defaults
    tt = Rake::TestTask.new(:example) do |t|
      t.libs = ['src', 'ext']
      t.pattern = 'test/tc_*.rb'
      t.verbose = true
    end
    assert_not_nil tt
    assert_equal :example, tt.name
    assert_equal ['src', 'ext'], tt.libs
    assert_equal 'test/tc_*.rb', tt.pattern
    assert_equal true, tt.verbose
    assert Task.task_defined?(:example)
  end

  def test_pattern
    tt = Rake::TestTask.new do |t|
      t.pattern = '*.rb'
    end
    assert_equal ['install.rb'], tt.file_list.to_a
  end

  def test_env_test
    ENV['TEST'] = 'testfile.rb'
    tt = Rake::TestTask.new do |t|
      t.pattern = '*'
    end
    assert_equal ["testfile.rb"], tt.file_list.to_a
  end

  def test_test_files
    tt = Rake::TestTask.new do |t|
      t.test_files = FileList['a.rb', 'b.rb']
    end
    assert_equal ["a.rb", 'b.rb'], tt.file_list.to_a
  end

  def test_both_pattern_and_test_files
    tt = Rake::TestTask.new do |t|
      t.test_files = FileList['a.rb', 'b.rb']
      t.pattern = '*.rb'
    end
    assert_equal ['a.rb', 'b.rb', 'install.rb'], tt.file_list.to_a
  end

end
