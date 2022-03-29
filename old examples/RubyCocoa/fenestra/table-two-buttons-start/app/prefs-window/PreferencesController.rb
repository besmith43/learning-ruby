#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class PreferencesController < OSX::NSArrayController
  include OSX

  ib_outlet :table
  COLUMN_IDS = [ :display_name, :app_name, :favorite, 
                 :class_name, :source ]

  def initWithCoder(decoder)   
    super_initWithCoder(decoder)
    std = NSUserDefaults.standardUserDefaults
    udc = NSUserDefaultsController.alloc.initWithDefaults_initialValues(std, {})
    useDefaultsController(udc)
    self
  end

  def useDefaultsController(defaults_controller)
    @defaults_controller = defaults_controller
    self.objectClass = TranslatorPreference
    @transformer = DataArrayTransformer.alloc.init

    self.objc_send(:bind, 'contentArray', 
                   :toObject, @defaults_controller,
                   :withKeyPath, 'values.translators',
                   :options, {  
                     NSHandlesContentAsCompoundValueBindingOption => true,
                     NSValueTransformerBindingOption => @transformer
                   })
  end

  def awakeFromNib
    super_awakeFromNib

    COLUMN_IDS.each do | id | 
      col = @table.tableColumnWithIdentifier(id)
      col.objc_send(:bind, 'value', 
                    :toObject, self,
                    :withKeyPath, "arrangedObjects.#{id}",
                    :options, {
                      NSAllowsEditingMultipleValuesSelectionBindingOption => true,
                      NSConditionallySetsEditableBindingOption => true,
                      NSCreatesSortDescriptorBindingOption => true,
                      NSRaisesForNotApplicableKeysBindingOption => true,
                    })
    end
  end

=begin
  # First version - doesn't pass test

  def add(sender)
    super_add(sender)
    @table.objc_send(:editColumn, 0,
                     :row, arrangedObjects.size-1,
                     :withEvent, nil,
                     :select, true)
  end

=end

=begin
  # First version - doesn't pass test

  def add(sender)
    super_add(sender)
    puts "after super_add #{arrangedObjects.size}" #(1) 
    @table.objc_send(:editColumn, 0,
                     :row, arrangedObjects.size-1,
                     :withEvent, nil,
                     :select, true)
  end

=end

=begin
  # Final version - or is it?

  def add(sender)
    addObject(TranslatorPreference.alloc.init) # (2) 
    @table.objc_send(:editColumn, 0,
                     :row, arrangedObjects.size-1,
                     :withEvent, nil,
                     :select, true)
  end

=end

=begin
  # Final version

  def add(sender)
    addObject(TranslatorPreference.alloc.init)
    selection = NSIndexSet.indexSetWithIndex(arrangedObjects.size-1)

    @table.objc_send(:selectRowIndexes, selection,
                     :byExtendingSelection, false)
    @table.objc_send(:editColumn, 0,
                     :row, arrangedObjects.size-1,
                     :withEvent, nil,
                     :select, true)
  end

=end
end
