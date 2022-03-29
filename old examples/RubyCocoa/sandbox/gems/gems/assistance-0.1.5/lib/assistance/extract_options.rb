#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Array extensions
class Array
  # Removes and returns the last member of the array if it is a hash. Otherwise,
  # an empty hash is returned This method is useful when writing methods that 
  # take an options hash as the last parameter. For example:
  #
  #   def validate_each(*args, &block)
  #     opts = args.extract_options!
  #     ...
  #   end
  def extract_options!
    last.is_a?(Hash) ? pop : {}
  end
end