#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

spec_require 'erubis'
require 'examples/templates/template_erubis'

describe 'Template Erubis' do
  behaves_like 'http'
  ramaze

  it '/' do
    get('/').body.strip.should ==
      "<a href=\"/\">Home</a> | <a href=\"/internal\">internal</a> | <a href=\"/external\">external</a>"
  end

  %w[/internal /external].each do |url|
    it url do
      html = get(url).body
      html.should.not == nil
      html.should =~ %r{<title>Template::Erubis (internal|external)</title>}
      html.should =~ %r{<h1>The (internal|external) Template for Erubis</h1>}
    end
  end
end
