#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class AppChoiceController < Controller

  # Upward to the view
  attr_writer :comboBox, :button, :label

  # Downward into guts
  attr_writer :preferences

  # PORT: Binding to the @button's state had no effect. Binding to this 
  # variable causes value transformers to be called at least. 
  # Note that I don't know how to make the variable KV-observable. 
  # kvc_accessor does not exist.
  # So I have to inform observers manually.
  def buttonStateCopy=(new_value)
    willChangeValueForKey(:buttonStateCopy)
    @buttonStateCopy = new_value
    didChangeValueForKey(:buttonStateCopy)
    $stderr.puts "Change to buttonStateCopy has been noted."
    @buttonStateCopy
  end

  def buttonStateCopy
    $stderr.puts "button state requested: #{@buttonStateCopy}"
    @buttonStateCopy
  end


  def awakeFromNib
    $stderr.puts "#{self.class} awakes from Nib"
    @comboBox.usesDataSource = true
    @comboBox.dataSource = self
    @comboBox.stringValue = @preferences.display_name_of_favorite_translator
    @button.title = 'Fenestrate'
    @button.alternateTitle = 'Heal'
    @buttonStateCopy = @button.state

    $stderr.puts "About to bind combobox.enabled."
    @comboBox.bind 'enabled', 
              toObject: self,
#              toObject: @button,
              withKeyPath: 'buttonStateCopy',
#              withKeyPath: 'state',
              options: {  
                          NSValueTransformerBindingOption => 
                          OffStateMeansTrueTransformer.alloc.init
                        }

    $stderr.puts "About to bind label.textcolor."
    @label.bind 'textColor', 
              toObject: self,
#              toObject: @button,
              withKeyPath: 'buttonStateCopy',
#              withKeyPath: 'state',
           options: {  
                       NSValueTransformerBindingOption => 
                       OffStateMeansEnabledColorTransformer.alloc.init
                     }
    super
    $stderr.puts "Leaving awakeFromNib"
  end

  def chooseOrHeal(sender)
    # PORT: Binding to the button state will cause the assignment below
    # to explode.
    $stderr.puts "Here I go, about to set the button state and trigger observers"
    @button.state = @button.state   # Hack: signal objects bound to state.
    $stderr.puts "I did not die a painful death."

    self.buttonStateCopy = @button.state    # PORT: fires observers. See above.

    if @button.state == NSOnState
      @last_choice = @comboBox.stringValue
      @translator = @preferences.translator_for_display_name(@last_choice)
      @translator.listen
      post(AppChosen, :app_name => @last_choice)
    else
      post(TimeToForgetApp, :app_name => @last_choice)
    end
  end

  # In role as data source

  def numberOfItemsInComboBox(ignored)
    display_names.size
  end

  def comboBox(ignored, objectValueForItemAtIndex: index)
    display_names[index]
  end

  def comboBox(ignored, indexOfItemWithStringValue: string)
    display_names.index(string) || NSNotFound
  end

  testable  

  def display_names
    @preferences.translator_display_names
  end
end
