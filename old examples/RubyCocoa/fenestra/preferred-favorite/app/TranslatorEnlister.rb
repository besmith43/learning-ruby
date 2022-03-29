#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Notifiable'


class TranslatorEnlister < OSX::NSObject

  include OSX
  include Announcements
  include Notifiable 


  DEFAULT_FAVORITE = "sample webapp com.exampler.counting"

  def init
    @defaults = NSUserDefaults.standardUserDefaults           # (1) 
    @defaults.registerDefaults(:favorite => DEFAULT_FAVORITE)   # (2) 


    k = Struct.new(:display_name, :app_name, :template)
    @translators = [
      k.new(DEFAULT_FAVORITE, "com.exampler.counting", Translators::CountingApp),
    ]

    
    connect_all_notification_observers

    super_init
  end

  def favorite; @defaults.objectForKey(:favorite); end     # (3) 



  def choices
    @translators.collect { | t | t.display_name } + 
      [ "for other apps: use.dot.format.name" ]
  end
  


  on_local_notification AppChosen do | notification |
    display_choice = notification[:app_name].to_ruby 
    @defaults.setObject_forKey(display_choice, :favorite)  # (4) 
    translator = @translators.find { | t |  t.display_name == display_choice }
    if translator
      translator.template.alloc.initForApp(translator.app_name).listen
    else
      Translators::ToString.alloc.initForApp(display_choice).listen
    end
  end

end


