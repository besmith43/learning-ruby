#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'util/Delegatable.rb'
require 'util/FenestraNotifiable'

class Controller
  include FenestraNotifiable
  include Delegatable
  include Announcements   # PORT: why is this needed?

  def awakeFromNib
    notifiable_awakeFromNib
  end
end
