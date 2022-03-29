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

spec_require 'xml/libxml', 'xml/xslt', 'ramaze/gestalt', 'rexml/document'

class TCTemplateXSLTController < Ramaze::Controller
  template_root 'spec/ramaze/template/xslt/'
  engine :XSLT
  trait :xslt_options => { :fun_xmlns => 'urn:test' }
  map '/'

  def index
    gestalt {
      hi 'tobi'
    }
  end

  def ruby_version
    @version = RUBY_VERSION

    gestalt {
      document
    }
  end

  def xslt_get_ruby_version
    @version
  end

  def products
    gestalt {
      order {
        first
        items
      }
    }
  end

  def xslt_get_products
    REXML::Document.new \
    gestalt {
      list {
        %w[Onion Bacon].each { |product|
          item product
        }
      }
    }
  end

  def concat_words
    gestalt {
      document
    }
  end

  def xslt_concat(*args)
    args.to_s
  end

  private

  def gestalt &block
    Ramaze::Gestalt.new(&block).to_s
  end
end

describe "XSLT" do
  behaves_like 'http'
  ramaze

  it "index" do
    get('/').body.should == "hi tobi"
  end

  it "ruby_version through external functions" do
    get('/ruby_version').body.should == RUBY_VERSION
  end

  it "external functions returning XML data" do
    get('/products').body.
      gsub(/<\?.+\?>/, '').strip.
      should == '<result><first>Onion</first><item>Onion</item><item>Bacon</item></result>'
  end

  it "parameters" do
    get('/concat_words').body.should == 'oneonetwoonetwothree'
  end
end
