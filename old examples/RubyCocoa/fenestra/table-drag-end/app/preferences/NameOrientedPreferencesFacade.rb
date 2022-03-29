#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# This name is deliberately bad so that it grates on me and grates on
# me and grates on me until I finally come up with the right
# decomposition for the classes that access user defaults.

class NameOrientedPreferencesFacade < OSX::NSObjectController
  include OSX

  def initWithCoder(decoder)
    super_initWithCoder(decoder)
    std = NSUserDefaults.standardUserDefaults
    udc = NSUserDefaultsController.alloc.initWithDefaults_initialValues(std, {})
    initWithDefaultsController(udc)
  end

  def initWithDefaultsController(defaults_controller)
    @defaults_controller = defaults_controller
    @transformer = DataArrayTransformer.alloc.init
    self.objc_send(:bind, 'content', 
                   :toObject, @defaults_controller,
                   :withKeyPath, 'values.translators',
                   :options, {  
                     NSHandlesContentAsCompoundValueBindingOption => true,
                     NSValueTransformerBindingOption => @transformer
                   })
    self
  end

  def display_name_of_favorite_translator
    content.each do | pref | 
      return pref.display_name if pref.favorite
    end
    return ''
  end

  def translator_display_names
    content.collect { | p | p.display_name }
  end

  def translator_for_display_name(display_name)
    pref = translator_pref_for_display_name(display_name)
    translator_class(pref.class_name).alloc.initForApp(pref.app_name)
  end


  testable

  def all_translator_prefs; content; end

  def translator_pref_for_display_name(display_name)
    forget_favorite
    match = content.find { | p | p.display_name == display_name }
    unless match
      match = TranslatorPreference.alloc.initWithHash(
                            :display_name => display_name,
                            :app_name => display_name,
                            :class_name => 'ToString')
      content << match
    end
    match.favorite = true
    push_into_rooted_keypath
    match
  end

  private

  def forget_favorite
    content.each { | t | t.favorite = false }
  end

  def push_into_rooted_keypath
    archived = @transformer.reverseTransformedValue(content)
    @defaults_controller.setValue_forKeyPath(archived,
                                             'values.translators')
  end

  def translator_class(class_name)
    Translators.const_get(class_name)
  end
end
