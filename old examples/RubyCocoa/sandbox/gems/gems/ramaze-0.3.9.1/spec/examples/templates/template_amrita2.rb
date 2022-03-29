#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

spec_require 'amrita2'
require 'examples/templates/template_amrita2'

describe 'Template Amrita2' do
  behaves_like 'http'
  ramaze

  it '/external' do
    html = get('/external').body
    html.should.not == nil
    html.should =~ %r{<title>Template::Amrita2 external</title>}
    html.should =~ %r{<h1>The external Template for Amrita2</h1>}
  end
end
