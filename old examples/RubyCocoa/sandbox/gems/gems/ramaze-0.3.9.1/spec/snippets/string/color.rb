#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe 'String#color' do
  it 'should define methods to return ANSI strings' do
    %w[reset bold dark underline blink negative
    black red green yellow blue magenta cyan white].each do |m|
      "string".respond_to? m
      "string".send(m).should.match(/\e\[\d+mstring\e\[0m/)
    end
  end
end
