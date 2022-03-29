#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

class Something

  def self.classmethod
    1 + 1
  end

  # Other edge cases:

  def opt_args(arg1, arg2 = 42, *args)
    arg3 = arg1 * arg2 * 7
    puts(arg3.to_s)
    return "foo"
  end

  def multi_args(arg1, arg2)
    arg3 = arg1 * arg2 * 7
    puts(arg3.to_s)
    return "foo"
  end

  def unknown_args(arg1, arg2)
    # does nothing
    return arg1
  end

  def determine_args
    5 == unknown_args(4, "known")
  end

  # TODO: sort list
  def bbegin
    begin
      1
    rescue SyntaxError => e1
      2
    rescue Exception => e2
      3
    else
      4
    ensure
      5
    end
  end

  def bbegin_no_exception
    begin
      5
    rescue
      6
    end
  end
end
