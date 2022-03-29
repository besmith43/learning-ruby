#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module PrefsWindowTests
  module TableCreation
    include OSX

    def create_table_with(columns)
      @table = rubycocoa_flexmock(NSTableView, 'table')
      @table.allowsMultipleSelection = true
      columns.each do | col |
        @table.addTableColumn(col)
      end
      @table
    end

    def mock_columns
      @columns = collect_columns do | id |
        col = rubycocoa_flexmock(NSTableColumn, "#{id} column") { | klass | 
          klass.alloc.initWithIdentifier(id)
        }
        col.should_receive(BindToObject, 4).by_default
        col
      end
    end

    def real_columns
      @columns = collect_columns do | id |
        NSTableColumn.alloc.initWithIdentifier(id)
      end
    end

    def collect_columns
      PreferencesController::COLUMN_IDS.collect do | id |
        yield id
      end
    end
  end

  module TableOperations
    include OSX

    def make_row_selection(*indices)
      select_nothing
      objects = indices.collect do | index | 
        @preferences_controller.arrangedObjects[index]
      end
      @preferences_controller.setSelectedObjects(objects)
    end

    def select_nothing
      current = @preferences_controller.selectedObjects
      @preferences_controller.removeSelectedObjects(current)
    end

    def selection_indexes(thing)
      set = if thing.is_a? NSArrayController
              thing.selectionIndexes
            else
              thing.selectedRowIndexes
            end
      set.to_a.sort
    end

    def defaults_contains?(display_name)
      @defaults_controller.find_by_display_name(display_name)
    end


    def row_count(thing)
      if thing.is_a? NSArrayController
        thing.arrangedObjects.count
      else
        thing.numberOfRows
      end
    end

    def favorites(thing)
      raw = case thing
            when NSArrayController
              thing.valueForKeyPath('arrangedObjects.favorite')
            when Hash, NSDictionary # fake user defaults controller
              thing.favorites
            end
      raw.to_ruby
    end


    def remove_last_translator(defaults_controller)
      translators = defaults_controller.valueForKeyPath('values.translators')
      translators.removeLastObject
      defaults_controller.setValue_forKeyPath(translators, 'values.translators')
    end
  end
end
