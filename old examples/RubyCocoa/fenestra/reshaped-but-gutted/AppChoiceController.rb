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
  ib_outlet :translatorEnlister   # (1) 



  def awakeFromNib
    NSLog("App Choice Controller awakes from Nib.")
    @comboBox.removeAllItems  # (2) 
    @translatorEnlister.choices.each do | t |
      @comboBox.addItemWithObjectValue(t)  # (3)
    end
    @comboBox.stringValue = @translatorEnlister.favorite  # (4) 
  end

  

  ib_action :chooseOrHeal

  def chooseOrHeal(sender)
    NSLog("AppChoiceController button pushed.")
    if @button.state == NSOnState
      NSLog("Fenestrate '#{@comboBox.stringValue}'.")
    else
      NSLog("Heal.")
    end
  end


end
