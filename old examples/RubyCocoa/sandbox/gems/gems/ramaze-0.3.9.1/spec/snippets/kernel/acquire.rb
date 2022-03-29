#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'
require 'fileutils'

describe 'acquire' do
  def require(name)
    @required << name
  end

  before do
    dir = 'tmp_dir_for_acquire'
    FileUtils.mkdir_p(dir + '/sub')

    %w[ foo.rb bar.rb baz.so baz.yml sub/baz.rb ].
      each do |path|
      FileUtils.touch("#{dir}/#{path}")
    end

    @required = []
  end

  it 'should not load a single file' do
    acquire 'tmp_dir_for_acquire/foo'
    @required.should == []
  end

  it 'should load dir' do
    acquire 'tmp_dir_for_acquire/sub/*'
    @required.should == %w[
      tmp_dir_for_acquire/sub/baz.rb]
  end

  it 'should be aliased to acquire' do
    acquire 'tmp_dir_for_acquire/sub/*'
    @required.should.not.be.empty
  end

  it 'should load {so,rb}, not others' do
    acquire 'tmp_dir_for_acquire/*'
    @required.sort.should == %w[
      tmp_dir_for_acquire/bar.rb
      tmp_dir_for_acquire/baz.so
      tmp_dir_for_acquire/foo.rb]
  end

  it 'should use globbing' do
    acquire 'tmp_dir_for_acquire/ba*'
    @required.sort.should == %w[
      tmp_dir_for_acquire/bar.rb
      tmp_dir_for_acquire/baz.so]
  end

  it 'should use recursive globbing' do
    acquire 'tmp_dir_for_acquire/**/*'
    @required.sort.should == %w[
      tmp_dir_for_acquire/bar.rb
      tmp_dir_for_acquire/baz.so
      tmp_dir_for_acquire/foo.rb
      tmp_dir_for_acquire/sub/baz.rb]
  end

  it 'should accept multiple arguments' do
    acquire 'tmp_dir_for_acquire/*', 'tmp_dir_for_acquire/sub/*'
    @required.sort.should == %w[
      tmp_dir_for_acquire/bar.rb
      tmp_dir_for_acquire/baz.so
      tmp_dir_for_acquire/foo.rb
      tmp_dir_for_acquire/sub/baz.rb]
  end

  FileUtils.rm_rf('tmp_dir_for_acquire')
end
