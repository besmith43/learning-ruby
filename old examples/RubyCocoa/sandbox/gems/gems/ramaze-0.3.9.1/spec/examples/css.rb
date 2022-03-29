#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
spec_require 'haml'
require 'examples/css'

describe 'CSSController' do
  behaves_like 'http'
  ramaze

  def req(path) r = get(path); [r.content_type, r.body] end

  it 'should cache generated css' do
    lambda{ req('/css/style.css') }.
      should.not.change{ req('/css/style.css') }
  end
end
