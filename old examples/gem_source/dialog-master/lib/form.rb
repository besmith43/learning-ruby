require_relative 'base'

module Dialog

  # Displays a form
  #
  # Corresponds to the --form box option. Use the field method to
  # define form fields
  #
  # Example
  #
  #   frm = Form.new do |f|
  #     f.text "Pick your poi.., er, vitamins"
  #     f.field "Fruit", 1, 1, "Strawberry", 1, 12
  #     f.field "Veggie", 2, 1, "Eggplant", 2, 12, 30, 50
  #   end
  #
  # Box option syntax:
  #   --form <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>...
  #
  class Form < Base

    def initialize(*options)
      @fields = []
      super *options
      @options.box_options[3] ||= 0 # Default form-height
    end

    # Adds a field to the form
    def field(label, ly, lx, item, iy, ix, flen=30, ilen=0)
      @fields << [label, ly, lx, item, iy, ix, flen, ilen]
    end

    def box_options
      super + @fields.flatten
    end

    def form_height(v)
      @options.box_options[3] = v
    end

  end

end
