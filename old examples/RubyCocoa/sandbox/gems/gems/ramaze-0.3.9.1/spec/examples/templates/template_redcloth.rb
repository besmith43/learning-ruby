#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

spec_require 'redcloth'
spec_require 'examples/templates/template_redcloth'

describe 'Template RedCloth' do
  behaves_like 'http'
  ramaze

  it '/' do
    html = get('/').body.strip
    html.should =~ %r(<a href=\"/\">Home</a>)
    html.should =~ %r(<a href=\"/internal\">internal</a>)
    html.should =~ %r(<a href=\"/external\">external</a>)
  end

  %w[/internal /external].each do |url|
    it url do
      name = url.gsub(/^\//, '')
      response = get(url)
      response.status.should == 200
      html = response.body
      html.should.not == nil
      html.should =~ %r(<title>Template::RedCloth #{name}</title>)
      html.should =~ %r(<h1>The #{name} Template for RedCloth</h1>)
    end
  end
end
