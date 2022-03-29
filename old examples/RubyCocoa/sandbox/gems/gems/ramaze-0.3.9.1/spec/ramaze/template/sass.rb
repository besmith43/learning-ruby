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

spec_require 'sass/engine'

class TCTemplateSassController < Ramaze::Controller
  map '/'
  template_root __DIR__/:sass
  engine :Sass

  define_method('style.css') do
%{
body
  :margin 1em

  #content
    :text-align center
}
  end
end

class TCTemplateSassLocalsController < Ramaze::Controller
  map '/options'
  engine :Sass
  trait :sass_options => { :style => :compact }

  def test
%{
body
  margin: 1em

  #content
    font:
      family: monospace
      size: 10pt
}
  end
end

describe "Sass templates" do
  behaves_like 'http'
  ramaze(:compile => true)

  it "should render inline" do
    r = get('/style.css')
    r.headers['Content-Type'].should == "text/css"
    r.body.strip.should ==
"body {
  margin: 1em; }
  body #content {
    text-align: center; }"
  end

  it "should render from file" do
    r = get('/file.css')
    r.headers['Content-Type'].should == "text/css"
    r.body.strip.should ==
"body {
  margin: 1em; }
  body #content {
    text-align: center; }"
  end

  it "should use sass options" do
    get('/options/test').body.should.not =~ /^ +/
  end
end
