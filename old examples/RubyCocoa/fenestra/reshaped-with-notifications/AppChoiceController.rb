#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Controller'

class AppChoiceController < Controller

  # Upward to the view
  ib_outlets :comboBox, :button

  # Downward into guts
  ib_outlet :translatorEnlister

  def awakeFromNib
    @comboBox.removeAllItems  
    @translatorEnlister.choices.each do | t |
      @comboBox.addItemWithObjectValue(t)
    end
    @comboBox.stringValue = @translatorEnlister.favorite
  end


  ib_action :chooseOrHeal




  def chooseOrHeal(sender)

    if @button.state == NSOnState
      @last_choice = @comboBox.stringValue  # (1)
      Center.postNotificationName_object_userInfo(AppChosen,  # (2) 
                                                  self,
                                                  :app_name => @last_choice)
    else
      Center.postNotificationName_object_userInfo(TimeToForgetApp,  # (3) 
                                                  self,
                                                  :app_name => @last_choice)
    end
  end


end
