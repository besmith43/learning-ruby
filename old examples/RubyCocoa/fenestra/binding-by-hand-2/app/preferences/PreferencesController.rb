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

  def initWithCoder(decoder)   # (1) 
    super_initWithCoder(decoder)
    self.objectClass = TranslatorPreference # (2) 
    @defaults_controller = NSUserDefaultsController.sharedUserDefaultsController # (3) 
    @transformer = DataArrayTransformer.alloc.init  # (4) 


    self.objc_send(:bind, 'contentArray',  # (5)
                   :toObject, @defaults_controller,
                   :withKeyPath, 'values.translators',
                   :options, {  # (6)
                     NSHandlesContentAsCompoundValueBindingOption => true,
                     NSValueTransformerBindingOption => @transformer
                   })

    self
  end

  def init   # (7)
    NSLog "I should never be called."
    raise "Init should not be called in an NSArrayController subclass."
  end
  

end
