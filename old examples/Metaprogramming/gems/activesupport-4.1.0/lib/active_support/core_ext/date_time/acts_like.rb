#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'date'
require 'active_support/core_ext/object/acts_like'

class DateTime
  # Duck-types as a Date-like class. See Object#acts_like?.
  def acts_like_date?
    true
  end

  # Duck-types as a Time-like class. See Object#acts_like?.
  def acts_like_time?
    true
  end
end
