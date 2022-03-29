#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Names of NSNotifications that pass between objects in this code.
# Does not include names of NSNotifications that come from external apps.

# Also does not include delegate method names, since those are defined
# by Apple.

module Announcements
  AppChosen = "appChosen"        # A new app is to be fenestrated.
  AppFactAvailable = "new info"  # Something known about the app. User might be interested.
  TimeToForgetApp = "Healing"    # Heal the fenestra.
end
