#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class TranslatorEnlister < OSX::NSObject
  include OSX
  include Announcements

  attr_reader :favorite
  
  def init
    @favorite = "sample webapp com.exampler.counting"

    k = Struct.new(:display_name, :app_name, :template)
    @translators = [
      k.new(@favorite, "com.exampler.counting", Translators::ToString),
    ]
    
    center = NSNotificationCenter.defaultCenter
    center.addObserver_selector_name_object(self, :enlist_translator,
                                            AppChosen, nil)

    super_init
  end
  
  def choices
    @translators.collect { | t | t.display_name } + 
      [ "for other apps: use.dot.format.name" ]
  end
  
  def enlist_translator(notification)
    display_choice = notification.userInfo[:app_name].to_ruby
    translator = @translators.find { | t |  t.display_name == display_choice }
    if translator
      translator.template.alloc.initForApp(translator.app_name).listen
    else
      Translators::ToString.alloc.initForApp(display_choice).listen
    end
  end
end
