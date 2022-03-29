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
  NeedsRubySource = "needs ruby source" # for source field of translator pref
  HasRubySource = "has ruby source"
end

# Other constants

DISABLED_COLOR = NSColor.grayColor
ENABLED_COLOR = NSColor.blackColor

NO_APP_DESIGNATION = "- No App -" 

DEFAULT_TRANSLATOR_DISPLAY_NAME='Display name'
DEFAULT_TRANSLATOR_APP_NAME='App Name'
DEFAULT_TRANSLATOR_CLASS_NAME='ToString'
