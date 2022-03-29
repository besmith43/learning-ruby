#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
# Add a +missing_name+ method to NameError instances.
class NameError #:nodoc:  
  # Add a method to obtain the missing name from a NameError.
  def missing_name
    $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ message
  end
  
  # Was this exception raised because the given name was missing?
  def missing_name?(name)
    if name.is_a? Symbol
      last_name = (missing_name || '').split('::').last
      last_name == name.to_s
    else
      missing_name == name.to_s
    end
  end
end
