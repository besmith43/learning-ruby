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
require 'ramaze/template'

module Ramaze
  module Template
    class TestTemplate < Template
      ENGINES[self] = %w[ test ]

      class << self
        def transform action
          action.values_at(:method, :params, :template).to_yaml
        end
      end
    end
  end
end

class TCTemplateController < Ramaze::Controller
  map '/'
  engine :TestTemplate
  template_root __DIR__/:template/:ramaze

  def index *args
  end

  def some_other_method *args
  end
end

class TCMultipleTemplateRoots < Ramaze::Controller
  map '/multiple'
  template_root __DIR__/:helper/:template, __DIR__/:template/:ezamar

  def sum
    @num1, @num2 = 1, 2
  end

  def num
    @n = 3
  end

  def render
    @n = 3
    render_template :num
  end
end

describe "testing ramaze template" do
  ramaze

  def getpage page
    content = Ramaze::Controller.handle(page)
    @action, @params, @file = YAML.load(content)
  end

  it "Gets a blank page" do
    getpage("/index")

    @action.should == "index"
    @params.should == []
    @file.should == nil
  end

  it "Maps the index" do
    getpage("/")

    @action.should == "index"
    @params.should == []
    @file.should == nil
  end

  it "Parses parameters" do
    getpage("/one/two/three")

    @action.should == "index"
    @params.should == %w{one two three}
    @file.should == nil
  end

  it "Knows about other methods" do
    getpage("/some_other_method")

    @action.should == "some_other_method"
    @params.should == []
    @file.should == nil
  end

  it "Uses external template files" do
    getpage("/external")

    @file.should =~ /external\.test$/
    @params.should == []
    file = TCTemplateController.template_root.first/'external.test'
    @file.should == file
  end
end

describe 'multiple template_roots' do
  def get(*args) Ramaze::Controller.handle(args) end

  it 'should work' do
    get('/multiple/sum').should == '3'
    get('/multiple/num').should == '3'
  end

  it 'should work with render_template' do
    get('/multiple/render').should == '3'
  end
end

describe "ramaze template engines" do
  Ramaze::Template::AVAILABLE_ENGINES.each do |engine|
    begin
      Ramaze::Template.const_get(engine)
    rescue LoadError, NameError
      # ignore missing template engines
    end
  end

  it "should not have dots at beginning of template extensions" do
    extensions = Ramaze::Template::ENGINES.map {|e,ext| ext }.flatten
    extensions.find_all {|e| e =~ /\A\./ }.should.be.empty
  end

end
