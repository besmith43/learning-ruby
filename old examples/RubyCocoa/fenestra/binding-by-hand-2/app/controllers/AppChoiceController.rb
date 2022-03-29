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
    # Upward to the view
    ib_outlets :comboBox, :button

    # Downward into guts
    ib_outlet :preferences  


    def awakeFromNib
      @comboBox.usesDataSource = true
      @comboBox.dataSource = self
      @comboBox.stringValue = @preferences.display_name_of_favorite_translator
      super
    end


    ib_action :chooseOrHeal do | sender |
      if @button.state == NSOnState
        @last_choice = @comboBox.stringValue.to_ruby
        translator = @preferences.translator_for_display_name(@last_choice)
        translator.listen  
        post(AppChosen, :app_name => @last_choice)
      else
        post(TimeToForgetApp, :app_name => @last_choice)
      end
    end

    # In role as data source


    def numberOfItemsInComboBox(ignored)
      @preferences.translator_display_names.size
    end



    def comboBox_objectValueForItemAtIndex(ignored, index)
      @preferences.translator_display_names[index]
    end



    def comboBox_indexOfItemWithStringValue(ignored, string)
      @preferences.translator_display_names.index(string) || NSNotFound
    end

  end
end
