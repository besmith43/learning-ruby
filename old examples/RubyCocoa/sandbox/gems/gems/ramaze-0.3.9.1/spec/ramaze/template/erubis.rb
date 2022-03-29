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

spec_require 'erubis'

class TCTemplateErubisController < Ramaze::Controller
  template_root __DIR__/:erubis
  engine :Erubis

  def index
    'Erubis Index'
  end

  def sum num1, num2
    @num1, @num2 = num1.to_i, num2.to_i
  end

  def inline *args
    @args = args
    "<%= @args.inspect %>"
  end
end

describe "Erubis" do
  behaves_like 'http'
  ramaze(:mapping => {'/' => TCTemplateErubisController})

  it "index" do
    get('/').body.should == 'Erubis Index'
  end

  it "sum" do
    get('/sum/1/2').body.strip.should == '3'
  end

  it "inline" do
    get('/inline/foo/bar').body.should == %w[foo bar].inspect
  end
end
