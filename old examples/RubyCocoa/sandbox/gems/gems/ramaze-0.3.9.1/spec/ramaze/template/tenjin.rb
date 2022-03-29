#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

spec_require 'tenjin'

class TCTemplateTenjinController < Ramaze::Controller
  template_root __DIR__/:tenjin
  engine :Tenjin

  def index
    'Tenjin Index'
  end

  def external(num1, num2)
    @context = {
      :num1 => num1.to_i,
      :num2 => num2.to_i
    }
  end

  def internal
    '<?rb @test = :internal ?>#{@test}'
  end

  def escape_html
    @context = {:html => "<br />"}
    '#{@html}${@html}'
  end
end

describe "Tenjin templates" do
  behaves_like 'http'
  ramaze(:mapping => {'/' => TCTemplateTenjinController})

  it "index" do
    get('/').body.should == 'Tenjin Index'
  end

  it "external" do
    get('/external/1/2').body.should == '3'
  end

  it "internal" do
    get('/internal').body.should == "internal"
  end

  it "escape html" do
    get('/escape_html').body.should == "<br />&lt;br /&gt;"
  end
end
