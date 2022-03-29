#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Proc

  # returns a hash of localvar/localvar-values from proc, useful for template
  # engines that do not accept bindings/proc and force passing locals via
  # hash
  #   usage: x = 42; p Proc.new.locals #=> {'x'=> 42}
  def locals
    instance_eval('binding').locals
  end

end
