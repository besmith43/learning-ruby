#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'controllers/Controller'

module Controllers

  class AppChoiceController < Controller
    # ...

    # Upward to the view
    ib_outlets :comboBox, :button

    # Downward into guts

    ib_outlet :preferences  #(1) 

    def awakeFromNib
      @comboBox.stringValue = @preferences.display_name_of_favorite_translator #(2)
      fill_combo_box
      super
    end

    def fill_combo_box
      @comboBox.removeAllItems
      @preferences.translator_display_names.each do | t |  #(3) 
        @comboBox.addItemWithObjectValue(t)
      end
    end

    # ...



    ib_action :chooseOrHeal do | sender |
      if @button.state == NSOnState
        @last_choice = @comboBox.stringValue.to_ruby
        translator = @preferences.translator_for_display_name(@last_choice) #(4) 
        translator.listen  #(5)
        fill_combo_box     #(6)
        post(AppChosen, :app_name => @last_choice)
      else
        post(TimeToForgetApp, :app_name => @last_choice)
      end
    end


  end

end
