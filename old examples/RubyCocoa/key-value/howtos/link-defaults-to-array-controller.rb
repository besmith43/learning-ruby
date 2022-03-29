#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Here are some defaults:

DEFAULTS = 
[   { "name" => "paul",    "age" => 13 },
    { "name" => "sophie",  "age" => 12 },
]

# Suppose we wanted to have an NSTableView colum that showed the names
# in a column, updated them when defaults changed, and propagated
# user changes into the defaults database. This shows how to make that
# happen. It uses a fake NSTableColumn (for the moment... change to
# make real one?)

require 'util'

def doit
  # Put things in the defaults data store
  defaults = NSUserDefaults.standardUserDefaults
  defaults.registerDefaults('children' => DEFAULTS)
  puts "The defaults system has been initialized with children:"
  puts defaults.arrayForKey("children")


  # Use a controller to access it.
  defaults_controller = NSUserDefaultsController.sharedUserDefaultsController
  puts "The defaults controller provides access to the children:"
  puts defaults_controller.valueForKeyPath("values.children")
  puts "... but you cannot retrieve an array of the names:"
  puts defaults_controller.valueForKeyPath("values.children.name")


  # An array controller will bind to the array of defaults, nothing that it
  # should be treated as an array of compound values (e.g., an NSDictionary
  # or object whose properties are key-value coded). 
  array_controller = NSArrayController.alloc.init
  array_controller.bind_toObject_withKeyPath_options("content",
                                                     defaults_controller, "values.children", 
                                                     NSHandlesContentAsCompoundValueBindingOption => true)
  puts "The Array Controller also holds the children:"
  puts array_controller.content
  puts "... and you can fetch the names"
  puts array_controller.valueForKeyPath("content.name")

  puts "We can change the defaults (adding dawn) and the change will bubble up."
  defaults.setObject_forKey(DEFAULTS + [{"name" => "dawn", "age" => 48}],
                            'children')
  puts array_controller.valueForKeyPath("content")


  puts "We can add to the array controller...."
  empty = NSMutableDictionary.dictionaryWithCapacity(2)
  array_controller.insertObject_atArrangedObjectIndex(empty, 0)
  array_controller.setSelectionIndex(0)
  puts "Here's the new empty entry in the array controller:"
  puts array_controller.valueForKeyPath("content")
  
  puts "But it mysteriously does not appear in the defaults controller:"
  puts NSUserDefaults.standardUserDefaults.arrayForKey("children")

  puts "This is odd, because similar connections work find when "
  puts "made with IB. Could be something about the run loop, but "
  puts "doing this within the run loop doesn't seem to help."


  

  return array_controller, defaults_controller, defaults
end


if $0 == __FILE__
  doit
end
