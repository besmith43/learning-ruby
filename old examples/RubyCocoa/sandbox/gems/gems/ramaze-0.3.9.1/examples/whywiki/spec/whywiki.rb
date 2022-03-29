#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'ramaze'
require 'ramaze/spec/helper'

spec_require 'bluecloth', 'hpricot'

$LOAD_PATH.unshift base = __DIR__/'..'

Db = Ramaze::YAMLStoreCache.new("#{base}/testwiki.yaml")
require 'start'

describe 'WikiController' do
  behaves_like 'http'

  def page(name)
    page = get(name)
    page.status.should == 200
    page.body.should.not == nil

    doc = Hpricot(page.body)
    title = doc.at('title').inner_html

    body = doc.at('body')
    return title, body
  end

  it 'should start' do
    ramaze :public_root   => base/:public,
           :template_root => base/:template
    get('/').status.should == 303
  end

  it 'should have main page' do
    t,body = page('/show/Home')
    t.should.match(/^MicroWiki Home$/)
    body.at('h1').inner_html.should == 'Home'
    body.at('a[@href=/edit/Home]').inner_html.should == 'Create Home'
  end

  it 'should have edit page' do
    t,body = page('/edit/Home')
    t.should.match(/^MicroWiki Edit Home$/)

    body.at('a[@href=/]').inner_html.should == '&lt; Home'
    body.at('h1').inner_html.should == 'Edit Home'
    body.at('form[@action=/save]>textarea[@name=text]').should.not == nil
  end

  it 'should create pages' do
    post('/save','text'=>'the text','page'=>'ThePage').status.should == 303
    page = Hpricot(get('/show/ThePage').body)
    body = page.at('body>div')
    body.should.not == nil
    body.at('a[@href=/edit/ThePage]').inner_html.should =='Edit ThePage'
    body.at('p').inner_html.should == 'the text'
  end

  FileUtils.rm("#{base}/testwiki.yaml")
end
