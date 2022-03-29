#!/usr/local/bin/ruby17 -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

begin
  require 'rubygems'
rescue LoadError
  $: << 'lib'
end
require 'inline'

class MyTest

  inline do |builder|

    builder.add_compile_flags %q(-x c++)
    builder.add_link_flags %q(-lstdc++)

    builder.c "
// stupid c++ comment
#include <iostream>
/* stupid c comment */
static
void
hello(int i) {
  while (i-- > 0) {
    std::cout << \"hello\" << std::endl;
  }
}
"
  end
end

t = MyTest.new()

t.hello(3)
