#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

begin require 'rubygems' rescue LoadError end
require 'inline'

class FastMath
  def factorial(n)
    f = 1
    n.downto(2) { |x| f *= x }
    return f
  end
  inline do |builder|
    builder.c "
    long factorial_c(int max) {
      int i=max, result=1;
      while (i >= 2) { result *= i--; }
      return result;
    }"
  end
end

math = FastMath.new

if ARGV.empty? then
  30000.times do math.factorial(20); end
else
  30000.times do math.factorial_c(20); end
end
