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

$LOAD_PATH.unshift base = __DIR__/'..'
spec_require 'hpricot', 'sequel'

require 'start'

describe 'Rammit' do
  behaves_like 'http'
  base = File.expand_path(__DIR__/'..')
  ramaze :template_root => base/'template', :public_root => base/'public'

  it 'should have intro page' do
    got = get('/')
    doc = Hpricot(got.body)
    form = doc.at(:form)
    form.at('textarea[@name=text]').should.not == nil
    form.at('input[@type=submit @value="Create a site"]').should.not == nil
  end

  it 'should create page from intro page' do
    got = post('/page/create', 'text' => 'Some text')
    refer = got.headers['Location']
    refer.should.not == nil
    got = get(refer)
    doc = Hpricot(got.body)
    doc.at('div#text').inner_html.should =~ /Some text/
  end
end
