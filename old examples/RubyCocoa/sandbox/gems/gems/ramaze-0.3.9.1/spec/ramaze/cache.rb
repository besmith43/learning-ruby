#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

caches = {:memory => 'Hash', :yaml => 'Ramaze::YAMLStoreCache'}

begin
  require 'memcache'
  caches[:memcached] = 'Ramaze::MemcachedCache'
rescue LoadError
  puts "skipping memcached"
end

caches.each do |cache, name|
  describe "#{name} setup" do
    it "should be assignable to Global" do
      Ramaze::Global.cache = cache
      Ramaze::Global.cache.to_s.should == name
    end

    it "should do .new" do
      @cache = Ramaze::Global.cache.new
      @cache.class.name.should == name
    end
  end

  describe "#{name} modification" do
    before do
      Ramaze::Global.cache = cache
      @cache = Ramaze::Global.cache.new
    end

    after do
      @cache.clear
    end

    it "should be assignable with #[]=" do
      @cache[:foo] = :bar
      @cache[:foo].should == :bar
    end

    it "should be retrievable with #[]" do
      @cache[:yoh] = :bar
      @cache[:yoh].should == :bar
    end

    it "should delete keys" do
      @cache[:bar] = :duh
      @cache.delete(:bar)
      @cache[:bar].should == nil
    end

    it "should show values for multiple keys" do
      @cache[:baz] = :foo
      @cache[:beh] = :feh
      @cache.values_at(:baz, :beh).should == [:foo, :feh]
    end

    it "different cache namespaces should not overlap" do
      Ramaze::Cache.add :foo
      Ramaze::Cache.add :bar

      key = "foobar"
      Ramaze::Cache.foo[key] = 'foo'
      Ramaze::Cache.bar[key] = 'bar'

      Ramaze::Cache.foo[key].should.not == Ramaze::Cache.bar[key]
    end

    FileUtils.rm(@cache.file) if cache == :yaml
  end
end
