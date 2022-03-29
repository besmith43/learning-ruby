Gem::Specification.new do |s|
  s.name        = 'dialog'
  s.version     = '0.1.2'
  s.date        = '2014-09-23'
  s.summary     = 'Interfacing with the dialog(1) program'
  s.description = <<-DESC
    Dialog is a ruby gem for interfacing with the dialog(1) program. \
    It does away with the manual command-line fiddling, allowing ruby programs operating in a commandline-environment to comfortably obtain user input. \
    Ncurses dialogs the easy way!
  DESC
  s.authors     = ['Martin Landers', 'Mavenlink']
  s.email       = ['elk@treibgut.net', 'dev+fork+dialog@mavenlink.com']
  s.files       = %W{
    lib/dialog.rb
    lib/base.rb
    lib/calendar.rb
    lib/checklist.rb
    lib/form.rb
    lib/fselect.rb
    lib/gauge.rb
    lib/infobox.rb
    lib/inputbox.rb
    lib/inputmenu.rb
    lib/menu.rb
    lib/mixedform.rb
    lib/msgbox.rb
    lib/passwordbox.rb
    lib/radiolist.rb
    lib/tailbox.rb
    lib/tailboxbg.rb
    lib/textbox.rb
    lib/timebox.rb
    lib/util.rb
    lib/yesno.rb
  }
  s.homepage    = 'http://rubygems.org/gems/dialog'
  s.license     = 'MIT'
end