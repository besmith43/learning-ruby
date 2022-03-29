require_relative 'base'
require_relative 'menu'

module Dialog

  # Displays an inputmenu.
  #
  # Example:
  #
  #   Inputmenu.new do |b|
  #     b.text "Bla bla"
  #     m.choice "/dev/hda1", "Backup partition /dev/hda1 using partimage"
  #     m.choice "/dev/hda2", "Backup partition /dev/hda2 using dd"
  #   end
  #
  # Box option syntax:
  #  --inputmenu <text> <height> <width> <menu height> <tag1> <item1>...
  #
  class Inputmenu < Menu
  end

end
