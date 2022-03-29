require_relative 'base'
require_relative 'checklist'

module Dialog

  # Displays a radiolist
  #
  # Example:
  #
  #   Radiolist.new do |m|
  #     m.text "Bla bla"
  #     m.choice "/dev/hda1", "Backup partition /dev/hda1 using partimage", :on
  #     m.choice "/dev/hda2", "Backup partition /dev/hda2 using dd"
  #   end
  #
  # Box option syntax:
  #   --radiolist <text> <height> <width> <list height> <tag1> <item1> <status1>...
  #
  class Radiolist < Checklist

    # Adds a choice to the list
    def choice(tag, item, status=:off, help=nil)
      super
    end

  end

end
