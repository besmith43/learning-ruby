require_relative 'base'

module Dialog

  # Displays a menu.
  #
  # Corresponds to the --menu box option. Use the choice method to
  # create menu items.
  #
  # Example:
  #
  #   steps = Dialog::menu do |m|
  #     m.text "Bla bla"
  #     m.choice "/dev/hda1", "Backup partition /dev/hda1 using partimage"
  #     m.choice "/dev/hda2", "Backup partition /dev/hda2 using dd"
  #   end
  #
  # Box option syntax:
  #   --menu <text> <height> <width> <menu height> <tag1> <item1>...
  #
  class Menu < Base

    def initialize(*options)
      @choices = []
      super *options
      @options.box_options[3] ||= 0 # Default menu-height
    end

    # Adds a choice to the menu
    def choice(tag, item, help=nil)
      choice = [tag, item]
      choice << help unless help.nil?
      @choices << choice
    end

    def box_options
      super + @choices.flatten
    end

    def menu_height(v)
     @options.box_options[3] = v
    end

  end

end
