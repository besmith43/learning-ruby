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

class MainController < Ramaze::Controller
  template :non_existant_method, :list
end

class TCActionOtherLayout < Ramaze::Controller
  map '/other'
  layout '/other_wrapper'
  template_root __DIR__/:template

  def index
    "Others Hello"
  end
end

describe "Testing Actionless Templates" do
  behaves_like 'http'
  ramaze :actionless_templates => false

  it "should not find template file for non existant method" do
    get('/non_existant_method').status.should == 404
    get('/non_existant_method2').status.should == 404
  end

  it "should render layout(without method) for normal action" do
    get('/other/index').body.should == '<p>Others Hello</p>'
  end
end
