#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class PreferencesController < NSArrayController
  include FenestraNotifiable
  include Announcements   # PORT: why is this needed?

  attr_writer :table
  COLUMN_IDS = [ :display_name, :app_name, :favorite, 
                 :class_name, :source ]

  def self.column_index_of(column_name)
    COLUMN_IDS.index(column_name)
  end

  def initWithCoder(decoder)   
    super
    std = NSUserDefaults.standardUserDefaults
    udc = NSUserDefaultsController.alloc.initWithDefaults std, initialValues: {}
    useDefaultsController(udc)
    self
  end

  def useDefaultsController(defaults_controller)
    @defaults_controller = defaults_controller
    self.objectClass = TranslatorPreference
    @transformer = DataArrayTransformer.alloc.init

    self.bind 'contentArray', 
         toObject: @defaults_controller,
         withKeyPath: 'values.translators',
         options: {  
                     NSHandlesContentAsCompoundValueBindingOption => true,
                     NSValueTransformerBindingOption => @transformer
                   }
  end

  def awakeFromNib
    super
    notifiable_awakeFromNib

    COLUMN_IDS.each do | id | 
      col = @table.tableColumnWithIdentifier(id)
      col.bind 'value', 
          toObject: self,
          withKeyPath: "arrangedObjects.#{id}",
          options: {
                      NSAllowsEditingMultipleValuesSelectionBindingOption => true,
                      NSConditionallySetsEditableBindingOption => true,
                      NSCreatesSortDescriptorBindingOption => true,
                      NSRaisesForNotApplicableKeysBindingOption => true,
                    }
    end
    @table.target = self
    @table.doubleAction = "doubleClick:"
  end

  def add(sender)
    addObject(TranslatorPreference.alloc.init)
    edit_cell_at(0, arrangedObjects.size-1)
  end

  def remove(sender)
    indexes = self.selectionIndexes
    return if indexes.to_a.empty?

    will_delete_last = indexes.containsIndex(arrangedObjects.count-1)
    removeObjectsAtArrangedObjectIndexes(indexes)

    # Can get along without this, since a selection of -1 is a no-op.
    # However, that's not guaranteed.
    return if arrangedObjects.to_a.empty?

    desired_selection_index = if will_delete_last
                                arrangedObjects.count - 1
                              else
                                indexes.lastIndex - indexes.count + 1
                              end
    self.selectionIndex = desired_selection_index
  end

  # Note: this is the wrong way to do it - should be in the model
  # (what's now the NameOrientedPreferenceFacade). But then there'd
  # be nothing Cocoa-specific about the solution.
  def observeValueForKeyPath keypath,
      ofObject: obj,
      change: change,
      context: context

    super

    # describe_observation(keypath, obj)
    if keypath == 'favorite' && obj.favorite
      new_favorite = obj
      make_old_favorite_false(new_favorite)
    end
  end

  def doubleClick(sender)
    return if @table.clickedRow == -1 
    return if @table.clickedColumn == -1 
    unless COLUMN_IDS[@table.clickedColumn] == :source
      edit_cell_at(@table.clickedColumn, @table.clickedRow)
      return
    end
    post(NeedsRubySource, :row => @table.clickedRow)
  end

  on_local_notification HasRubySource do | notification |
    row = notification[:row]
    update_source_at_clicked_index(row, notification['source'])
  end

  protected

  def edit_cell_at(col, row)
    select_row_with_index(row)
    
    @table.editColumn col,
           row: row,
           withEvent: nil,
           select: true
  end

  def make_old_favorite_false(new_favorite)
    old_favorite_index = favorite_index_excluding(new_favorite)
    if old_favorite_index
      update_changed_object_at_index(old_favorite_index) do | pref |
        pref.favorite = false
      end
    end
  end

  def update_source_at_clicked_index(index, new_source)
    update_changed_object_at_index(index) do | pref |
      pref.source = new_source
    end
  end

  def select_row_with_index(index)
    selection = NSIndexSet.indexSetWithIndex(index)
    @table.selectRowIndexes selection,
           byExtendingSelection: false
  end

  def favorite_index_excluding(new_favorite)
    all_indexes = (0...arrangedObjects.count)
    all_indexes.find do | index | 
      pref = arrangedObjects[index]
      next if pref.was_originally_identically?(new_favorite)
      next unless pref.favorite
      true 
    end
  end

  def update_changed_object_at_index(index)
    obj = arrangedObjects[index]
    removeObjectAtArrangedObjectIndex(index)
    yield(obj)
    insertObject obj, atArrangedObjectIndex: index
  end
  

  def describe_observation(keypath, obj)
    NSLog keypath
    case obj
    when TranslatorPreference
      NSLog obj.to_s
    else
      NSLog "#{obj.class}(#{obj.object_id})"
    end
  end
end
