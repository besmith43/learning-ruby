#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Preferences < OSX::NSObject
  include OSX

  def init
    only = TranslatorPreference.alloc.initWithHash(
                :display_name => "sample webapp com.exampler.counting",
                :app_name => "com.exampler.counting",
                :class_name => 'CountingApp',
                :favorite => true,
                :source => nil)
    @defaults = NSUserDefaults.standardUserDefaults
    @defaults.registerDefaults(:translators => collect_archived([only]))
    super_init
  end

  def display_name_of_favorite_translator
    with_translator_cache do
      fav = translator_preferences.find_favorite
      fav ? fav.display_name : ''
    end
  end

  def translator_display_names
    with_translator_cache do
      translator_preferences.collect { | t | t.display_name }
    end
  end

  def translator_for_display_name(display_name)
    with_changed_translators do
      forget_favorite_translator
      pref = translator_preferences.find_by_display_name(display_name)
      unless pref
        pref = TranslatorPreference.alloc.initWithHash(
                          :display_name => display_name, 
                          :app_name => display_name,
                          :class_name => 'ToString',
                          :favorite => true,
                          :source => nil)
        translator_preferences << pref
      end
      pref.favorite = true
      translator_class(pref.class_name).alloc.initForApp(pref.app_name)
    end
  end

protected

  # 
  def translator_class(class_name)
    Translators.const_get(class_name)
  end

  attr_reader :translator_preferences

  # Caching

  # I cache, but not because I'm worried about efficiently. But if you
  # read preferences multiple times, it's awfully easy to read them, 
  # change something, then accidentally reread and overwrite the change. 
  # So I have two caching methods. One just makes sure the translator
  # preference is up-to-date (used for read-only methods). The other 
  # writes changes back at the end.

  def with_changed_translators
    retval = with_translator_cache { yield } 
    @defaults.setObject_forKey(collect_archived(translator_preferences),
                                                :translators)
    retval
  end

  def with_translator_cache

    archived = @defaults.objectForKey(:translators)
    @translator_preferences = archived.collect do | nsdatum | 
      NSKeyedUnarchiver.unarchiveObjectWithData(nsdatum)
    end


    # These are "singleton methods". They're a way of attaching
    # methods to a specific object, in this case an array. I like
    # writing code like array.find_by_display_name. To me, it reads
    # better than array.find {...}. The form of the name is inspired
    # by Rails. (In Rails, they're auto-generated, but I haven't 
    # bothered.)
    def @translator_preferences.find_by_display_name(val)
      find { | elt | elt.display_name.to_ruby == val }
    end

    # find_by_favorite(val) doesn't work well because there are
    # too many ways of saying "true" or "false" in Ruby.
    def @translator_preferences.find_favorite
      find { | elt | elt.favorite }
    end
    yield
  end



  def collect_archived(objects)
    objects.collect do | o | 
      NSKeyedArchiver.archivedDataWithRootObject(o)
    end
  end


  def forget_favorite_translator
    translator_preferences.each do | pref |
      pref.favorite = false
    end
  end
end


