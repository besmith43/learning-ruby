require_relative 'base'
require_relative 'menu'

module Dialog

  # Displays a checklist
  #
  # Corresponds to the --checklist box option. Use the choice method to
  # define list items
  #
  # Example:
  #
  #   steps = Dialog::checklist do |m|
  #     m.text "Bla bla"
  #     m.choice "/dev/hda1", "Backup partition /dev/hda1 using partimage", :on
  #     m.choice "/dev/hda2", "Backup partition /dev/hda2 using dd", :off
  #   end
  #
  # Box option syntax:
  #   --checklist <text> <height> <width> <list height> <tag1> <item1> <status1>...
  #
  class Checklist < Menu

    # Adds a choice to the checklist
    def choice(tag, item, status=:on, help=nil)
      choice = [tag, item, status.to_s]
      choice << help unless help.nil?
      @choices << choice
    end

  end

end
