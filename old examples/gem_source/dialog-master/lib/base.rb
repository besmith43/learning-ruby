require 'date'
require_relative 'util'

# Module containing all dialog stuff, to avoid namespace clutter
module Dialog

  # Constants for dialog(1) exit statii
  Ok = Yes = 0
  Cancel = No = 1
  Help = 2
  Extra = 3
  Escape = 255
  Error = -1

  # Base class collecting common options and handlers for a dialog
  class DialogOptions

    attr_reader :box_options, :common_options, :handlers

    # Initializes the collector with default options.
    def initialize(height = 0, width = 0)
      @handlers = {}
      @box_options = ["Er, perhaps you should set some text using the text method!", height, width]
      @common_options = {}
      yield self if block_given?
    end

    # Sets the label for the ok button and optionally attaches a block as ok handler
    def yes(label="Yes", &block)
      @common_options.store('yes-label', label)
      @handlers[:yes] = block
    end

    # Sets the label for the ok button and optionally attaches a block as ok handler
    def no(label="No", &block)
      @common_options.store('no-label', label)
      @handlers[:no] = block
    end

    # Sets the label for the ok button and optionally attaches a block as ok handler
    def ok(label="OK", &block)
      @common_options.store('ok-label', label)
      @handlers[:ok] = block
    end

    # Sets the label for the cancel button and optionally attaches a block as cancel handler
    def cancel(label="Cancel", &block)
      @common_options.store('cancel-label', label)
      @handlers[:cancel] = block
    end

    # Sets the label for the extra button and optionally attaches a block as extra handler
    def extra(label="Rename", &block)
      @common_options.store('extra-button', nil)
      @common_options.store('extra-label', label)
      @handlers[:extra] = block
    end

    # Attaches a block as help handler. No label can be specified, because help is hardwired to F1.
    def help(&block)
      @common_options.store('help-button', nil)
      @handlers[:help] = block
    end

    # Sets the dialog's width
    def width(w)
      @box_options[2] = w
    end

    # Sets the dialog's height
    def height(h)
      @box_options[1] = h
    end

    # Sets the dialog's text
    def text(t)
      @box_options[0] = t
    end

    # Map unknown method names to common options
    def method_missing(name, *args)
      @common_options.store(name.to_s.gsub('_','-'), args);
    end

    # Creates a semi-shallow copy of the object
    #
    # The object and its immediate data structures are copied. The instances
    # they refer to, however, are not.
    def dup
      opts = DialogOptions.new
      opts.box_options = @box_options.dup
      opts.handlers = @handlers.dup
      opts.common_options = @common_options.dup
      opts
    end
  end

  protected

  def box_options=(opts)
    @box_options = opts
  end

  def common_options=(opts)
    @common_options = opts
  end

  def handlers=(opts)
    @handlers = opts
  end

  private

  # Default DialogOptions instance
  DefaultOptions = DialogOptions.new

  public
  # Configures default options for all dialogs
  #
  # Returns the DialogOptions instance, that is used as the default
  # by all dialog objects (unless explicitly overridden).
  # Supports block-style initialization:
  #
  #  Dialog::default_options do |d|
  #    d.backtitle "Camelot!"
  #    d.no_shadow
  #  end
  #
  def self.default_options
    yield DefaultOptions if block_given?
    DefaultOptions
  end

  # Base-class for all dialog "widgets".
  #
  # Contains functionality common to all widgets, like the
  # handling of common options, assembling the command-line
  # and invoking the dialog command.
  #
  # Author: Martin Landers <elk@treibgut.net>
  class Base

    attr_reader :output

    private

    # The command used to invoke dialog
    Dialog_cmd =  (`which dialog` || "/usr/bin/dialog").chomp

    public
    # Initializes a dialog "widget".
    #
    # Does base initialization common to all widgets.
    def initialize(height = 0, width = 0, options = Dialog::default_options.dup)
      @options = options
      @options.height(height) if height != 0
      @options.width(width) if width != 0
      yield self if block_given?
    end

    # Predicate, testing if the dialog was left with the YES button
    def yes?
      @exitstatus == Yes
    end

    # Predicate, testing if the dialog was left with the NO button
    def no?
      @exitstatus == No
    end

    # Predicate, testing if the dialog was left with the OK button
    def ok?
      @exitstatus == Ok
    end

    # Predicate, testing if the dialog was left using the Cancel button
    def cancel?
      @exitstatus == Cancel
    end

    # Predicate, testing if the dialog was left using the Extra button
    def extra?
      @exitstatus == Extra
    end

    # Predicate, testing if the dialog was left using the Help button
    def help?
      @exitstatus == Help
    end

    # Predicate, testing if the dialog was left using the Help button
    def escape?
      @exitstatus == Escape
    end

    # Gets the fixed-position box options
    #
    # Returns a duplicate, so subclasses can use destructive
    # array operations like <<.
    def box_options
      @options.box_options.dup
    end

    # Gets the registered handlers
    #
    # Returns a duplicate, so subclasses can use destructive
    # array operations like <<.
    def handlers
      @options.handlers.dup
    end

    # Gets the common options for the dialog.
    #
    # The options are stored as a hash mapping option names to value arrays
    # or +nil+ if no value is associated with the option.
    #
    # Returns a duplicate, so subclasses can use destructive
    # array operations like <<.
    def common_options
      @options.common_options.dup
    end

    # Turns the name of the current class into a box option
    #
    # For example, class FSelect becomes --fselect
    def box_type
      "--#{self.class.name.split('::').last.downcase}"
    end

    # Delegate unknown method names to the options instance
    def method_missing(name, *args, &block)
      @options.send(name, *args, &block)
    end

    # Asynchronously displays the dialog
    #
    # That is, forks off the dialog program in a seperate
    # process and returns immediately, without waiting for
    # user input. This is useful for widgets like Gauge,
    # that require concurrent processing and may receive
    # updates from the application. Note, that you must
    # use the wait method to wait until the user has closed
    # the dialog, before you can use any of the status
    # methods of the dialog like ok?.
    def show
      invoke
    end

    # Synchronously displays the dialog
    #
    # That is, invokes the dialog program and blocks until
    # it has returned. The method returns self, just like
    # the wait method (see example there). Use this method
    # to display simple input dialogs, that don't require
    # concurrent processing.
    def show!
      invoke
      wait
    end

    # Waits for the user to close/cancel the dialog.
    #
    # That is, waits for the dialog program to return.
    # Returns self. Use the ok?, cancel?, etc. predicates
    # to determine exit status, like this:
    #
    #   if dlg.wait.ok?
    #     ...
    #   else
    #     ...
    #   end
    #
    # If forking or waiting for the process fails, a SystemCallError
    # is raised. If dialog exits with an error message, a DialogError
    # is raised.
    def wait
      raise DialogError, "No dialog to wait for" unless @pid

      pid, status = Process.wait2(@pid)
      @exitstatus = status.exitstatus
      @output = @stderr.read

      if @exitstatus == Escape || @exitstatus == Error
        # Raise an exception if dialog printed an error message
        # If not, the user just exited the dialog using ESC
        raise DialogError.new(commandline_arguments), @output unless @output.empty?
      end

      case @exitstatus
        when Ok then
          handlers[:ok].call(self, @output) if handlers[:ok]
          handlers[:yes].call(self, @output) if handlers[:yes]
        when Cancel then
          handlers[:cancel].call(self, @output) if handlers[:cancel]
          handlers[:no].call(self, @output) if handlers[:no]
        when Extra then
          handlers[:extra].call(self, @output) if handlers[:extra]
        when Help then
          handlers[:help].call(self, @output) if handlers[:help]
      end
      self
    ensure
      @pid = @stdin = @stderr = nil
    end

    # Gets the commandline arguments that show would pass to dialog.
    #
    # Use this method if you only want to use the dialog classes as
    # fancy string builders and need to invoke the dialog program
    # yourself. Note, that the arguments will be returned as an array
    # to avoid quoting problems, and will not include the actual
    # command used to invoke dialog program, only the commandline options.
    def commandline_arguments
      collect_options
    end

    protected

    # Asynchronously invokes the dialog command
    #
    # Initializes @pid, @stdin and @stderr. Resets @exitstatus.
    def invoke
      @exitstatus = nil
      @pid, @stdin, stdout, @stderr = Util.popen3(Dialog_cmd, collect_options, :stdout => STDOUT)
    end

    # Collects all the options into an options string suitable for dialog(1)
    def collect_options
      opts = []

      common_options.each do |option,value|
        opts << "--#{option}"
        value = [value].flatten
        opts += value unless value.nil? || value.empty?
      end

      opts << box_type
      opts += box_options
      opts.map(&:to_s)
    end
  end

  # Used to signal exceptions when invoking dialog
  class DialogError < RuntimeError
    def initialize(args)
      @args = args
    end

    def to_s
      "dialog has reported an error\n#{super}\narguments: #{@args.inspect}\n"
    end
  end
end
