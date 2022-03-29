require_relative 'base'

module Dialog

  # Displays a mixed form
  #
  # Corresponds to the --mixedform box option. Use the field method or
  # one of the specialized helper methods like password to define form
  # fields.
  #
  # Example
  #
  #   steps = MixedForm.new do |m|
  #     m.text "Authentication"
  #     m.field "User", 1, 1, "", 1, 10, 40, 38, 0
  #     m.password "Password", 2, 1, "", 2, 10, 40, 38
  #   end
  #
  # Box option syntax:
  #   --mixedform <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1> <itype>...
  #
  class MixedForm < Form

    # Adds a field to the form
    def field(label, ly, lx, item, iy, ix, flen=30, ilen=0, itype=0)
      @fields << [label, ly, lx, item, iy, ix, flen, ilen, itype]
    end

    # Adds an input field to the form
    def input(label, ly, lx, item, iy, ix, flen=30, ilen=0)
      field(label, ly, lx, item, iy, ix, flen, ilen, 0)
    end

    # Adds a password field to the form
    def password(label, ly, lx, item, iy, ix, flen=30, ilen=0)
      field(label, ly, lx, item, iy, ix, flen, ilen, 1)
    end

    # Adds a readonly field to the form
    def readonly(label, ly, lx, item, iy, ix, flen=30, ilen=0)
      field(label, ly, lx, item, iy, ix, flen, ilen, 2)
    end

    # Adds a disabled field to the form
    def disabled(label, ly, lx, item, iy, ix, flen=30, ilen=0)
      field(label, ly, lx, item, iy, ix, flen, ilen, 3)
    end

  end

end
