#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#
#  AppController.rb
#  PopupToDefaultsViaArrayController
#
#  Created by Brian Marick on 7/26/08.
#  Copyright (c) 2008 Exampler Consulting. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject
  include OSX
  
  ib_outlet :arrayController
  ib_outlet :firstNameField
  
  def awakeFromNib
    defaults = NSUserDefaults.standardUserDefaults
    defaults.registerDefaults('people' => [
                  { 'firstName' => 'Dawn',
                    'lastName' => 'Marick',
                    'eyeColor' => 'blue'},
                  { 'firstName' => 'Brian',
                    'lastName' => 'Marick',
                    'eyeColor' => 'brown'},
                  ])
                  

  
  end
  
  ib_action :changeSelection do | sender | 
    @arrayController.selectionIndex = sender.indexOfSelectedItem
  end
  
  ib_action :insertNamelessPerson do | sender | 
    @arrayController.insertObject_atArrangedObjectIndex({}, 0)
    @arrayController.selectionIndex = 0
    @firstNameField.selectText(sender)
  end
  
  
end
