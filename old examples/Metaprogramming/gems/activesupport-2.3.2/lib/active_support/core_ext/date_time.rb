#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'date'
require 'active_support/core_ext/time/behavior'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/date_time/conversions'

class DateTime
  include ActiveSupport::CoreExtensions::Time::Behavior
  include ActiveSupport::CoreExtensions::Time::Zones
  include ActiveSupport::CoreExtensions::DateTime::Calculations
  include ActiveSupport::CoreExtensions::DateTime::Conversions
end
