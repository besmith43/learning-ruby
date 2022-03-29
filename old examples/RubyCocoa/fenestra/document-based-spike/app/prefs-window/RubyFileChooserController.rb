#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class RubyFileChooserController < Controller

  def init
    initWithPanel(NSOpenPanel.openPanel)
  end

  def initWithPanel(panel)
    super_init
    panel.title = "Choose a Ruby File"
    panel.prompt = "Choose"
    panel.allowsMultipleSelection = false
    @panel = panel
    self
  end

  on_local_notification NeedsRubySource do | notification | 
    return unless @panel.runModalForTypes(['rb']) == NSOKButton
    post(HasRubySource,
         :row => notification[:row], :source => @panel.filename)
  end

  testable

  attr_reader :panel
end
