# dialog

Dialog is a ruby gem for interfacing with the dialog(1) program. It does away
with the manual command-line fiddling, allowing ruby programs operating in a
commandline-environment to comfortably obtain user input. Ncurses dialogs the
easy way!

# Installation

Dialog is available as a ruby gem from rubyforge[http://www.rubyforge.org].
Using RubyGems[http://docs.rubygems.org/] you can install dialog with the
commandline:

	gem install dialog

<em>Note: The dialog gem does not include the dialog program or ncurses, you
need to install these seperately</em> (see below).

For development install see: `http://guides.rubygems.org/make-your-own-gem/`

# License

dialog is Copyright (c) 2006-2008 Martin Landers. It is free software,
and may be redistributed under the terms of the GNU General Public License.
See COPYING.

---

# Ncurses and the dialog program

A simple user interface goes a long way in terms of making an application user
friendly (so does a good commandline interface, but you're already got that,
haven't you?). However, not all applications enjoy the luxury of living in a
rich GUI environment. Running an X server (or any other fancy GUI) on an
embedded platform may be overkill or not supported at all. Maybe you're
writing some software to get an X Server running in the first place, or
constrained to a minimal bootable version of linux. Or, perhaps, you're just
plain fond of console tools.

Whatever the reason, if you're in need of a simple "console GUI",
dialog(1)[http://invisible-island.net/dialog/] is the tool for the job. In
fact, the ncurses(3)[http://invisible-island.net/ncurses/] library is the tool
for the job. However, pure ncurses is notoriously hard to use. It only offers
primitive operations like moving the cursor or putting characters on the
screen. Ncurses has no notion of "widgets", like text-boxes or menus.

Enter dialog. dialog is a commandline wrapper for the ncurses library,
that knows how to display simple dialog types. dialog has been designed
with shell-scripts or scripting languages in mind. When dialog is invoked, it
displays a single dialog (or a series of dialogs) and returns to the calling
process, informing it of the selected options. Every aspect of a dialog's
appearance can controlled by commandline parameters (for details, check out
the dialog man page in section 1). For example, this commandline displays
everybody's favourite Monty Python Yes/No-style question (from "Monthy Python
and the Holy Grail", that is):

 	dialog --yes-label "Blue" --no-label "Yellow" --yesno "What... is your favourite colour?" 0 0 

While this is a huge improvement over manually "drawing" each dialog with
ncurses primitives, the tasks of building commandlines for dialog and parsing
its output still are complex and not very ruby-like. Hence, the dialog gem,
which handles these tasks and offers a simple, yet powerful API for invoking
dialog.

# The dialog gem API

The dialog gem wraps each type of dialog (<em>box type</em> in dialog-lingo)
supported by the dialog program into a class. The class will have the same
name as the box type, with the first letter capitalized. So, the
<tt>--yesno</tt> box type becomes the Dialog::Yesno class (all classes live
in the Dialog module, to avoid namespace clutter). So, our example from above
becomes:

	require 'rubygems'
	require 'dialog'
	
	include Dialog
	
	yn = Yesno.new do |d|
	  d.text "What... is your favourite colour?"
	  d.yes "Blue"
	  d.no "Yellow"
	end
	yn.show!

Now, that's better. Note, that in order to actually display the dialog, we
need to invoke the <tt>show!</tt> method of the dialog object. This allows us
to pre-initialize complex dialog objects and display them at a later time (or
even multiple times througout an application's lifetime).

But how do we know what our humble knight, er, user selected? By asking, of
course!  All dialog objects offer a number of predicate methods like
<tt>ok?</tt>, <tt>yes?</tt> or <tt>no?</tt> that tell us the outcome of
displaying the dialog. So, we could use the following code to tell if we need
to toss the knight into the volcano:

	  if yn.yes?
	    puts "Go on. Off you go."
	  else
	    puts "auuuuuuuugh."
	  end

Obviously, calling these methods only makes sense after we've actually
displayed the dialog. Let's look at the interface in a bit more detail.
  
# Initializing dialog objects

Before a dialog object can be displayed, it must be initialized. At the very
least, we need to set a text for the dialog, using the +text+ method, but we
may want to set a number of other options, like the captions of the yes and no
buttons, as we've done above.

The dialog gem supports two ways of initializing a dialog object. The
block-style initialization seen above, and plain initialization through
setter methods. In addition to per-dialog options, the gem also supports
setting application-wide defaults for all dialogs or using a "template"
to initialize a dialog's options.

Before we look at this in more detail, we need to introduce one distinction.
The dialog program supports two kinds of options, <tt>box options</tt> and
<tt>common options</tt>. Box options are specific to the kind of dialog we
wish to display. For example, a menu requires one or more choices whereas a
file selection box needs an intial pathname. On the other hand, common
options, like a background title (<tt>--backtitle</tt>) or wheter the dialog
should be rendered with a shadow, are applicable for all, or at least more
than one, dialog type.

Because box options are dialog-specific, they are set using specialized
methods in the individual classes. For example, the +choice+ method in
Dialog::Menu adds all box options for a single menu choice in one go. Common
options, on the other hand, can always be set using methods of the same name
as the option, with hyphens replaced by underscores (Check out the dialog(1)
manpage for the options supported by your copy of the dialog program). So, for
example, the <tt>--no-shadow</tt> option may be set by invoking the
+no_shadow+ method.

	  Yesno.new do |yn|
	    yn.no_shadow
	  end

In fact, common options are not checked at all. So, if you know your version
of the dialog program supports a special option called <tt>--hug-bunnies</tt>,
taking two arguments, just call

	  Msgbox.new do |m|
	    m.hug_bunnies "arg1" 2
	  end

to pass <tt>--hug-bunnies arg1 2</tt> to dialog and be extra nice to our small
furry friends. Note, however, that you need to be careful when using options
changing the I/O-behaviour of dialog. You might break the gem.

A small number of convenience methods for setting the most frequently used
common and box options is built-in to all dialog classes. This includes button
handling methods like +yes+ or +cancel+ and the +width+, +height+ and +text+
methods.

## Block-style initialization

In the examples so far, we've been using the <em>block-style
initialization</em> for the dialog object. Block-style initialization is the
preferred way of initializing a dialog instance as it keeps visual clutter at
a minimum, clearly grouping together all option settings. Consider this more
complex example:

	  Checklist.new do |c|
	    c.backtitle "Indiana Jones and the Temple of Doom"
	    c.defaultno
	    c.width 60
	    c.height 10
	    c.title "Dinner menu"
	    c.text "Dinner is ready, please choose your meal"
	    c.choice "Critters", "Crispy Critters", :on
	    c.choice "Snake", "Snake Surprise", :on
	    c.choice "Monkey", "Iced Monkey Brain", :off
	    c.ok "Serve it!"
	    c.cancel "I'm not hungry"
	    c.extra "Soup?"
	  end.show!

## Setter-based initialization

Instead of using block-style initialization, we can also initialize dialog
objects like any other plain object. This may be preferable when complex
"computation" is needed between the initialization steps, or we can use this
to change options of an already initialized dialog. Here's the same example
again, this time using setter-based initialization:

	  c = Checklist.new do
	  c.backtitle "Indiana Jones and the Temple of Doom"
	  c.defaultno
	  c.width 60
	  c.height 10
	  c.title "Dinner menu"
	  c.text "Dinner is ready, please choose your meal"
	  c.choice "Critters", "Crispy Critters", :on
	  c.choice "Snake", "Snake Surprise", :on
	  c.choice "Monkey", "Iced Monkey Brain", :off
	  c.ok "Serve it!"
	  c.cancel "I'm not hungry"
	  c.extra "Soup?"
	  c.show!

## Setting default options

To avoid repeating ourselves (violating the DRY-principle) when different
dialogs require common options, the dialog gem supports setting default
options for all dialogs or a group of dialogs. It does this by virtue of the
DialogOptions class. Each dialog instance contains an instance of this class,
that is responsible for collecting the options of that dialog. In fact, all the
fancy option-collecting methods explained above are courtesy of DialogOptions.
The dialog instances just expose the interface (by delegating unknown methods
to the DialogOptions instance) directly, to save us some typing. 

Whenever you create an instance of a dialog class, the instance looks for a
DialogOptions instance to clone. Unless you say otherwise, the
application-wide default instance is copied. You can obtain this instance
using the <tt>Dialog::default_options</tt> method. For reasons of consistency,
the +default_options+ method supports block-style initialization, just like
the dialog objects.

So, supposing you are having more than one dialog dealing with the adventures
of Indy in the Temple of Doom, you can set the backtitle for all of them
using:

	  Dialog::default_options do |d|
	    d.backtitle "Indiana Jones and the Temple of Doom"
	  end
	
	  Checklist.new do |c|
	    # Will have backtitle set to the default established above
	    c.defaultno
	    c.width 60
	    ...
	  end

Note, that you have to manipulate the default options instance _before_
creating the dialogs (because the instance is _cloned_).

Setting default options goes a long way, but you can get even fancier and
initialize (groups of) dialogs using your own +DialogOptions+ templates. To do
this, just create and configure +DialogOptions+ instances, and pass them to
the constructors of your dialogs. Note, that you have to specify a size for
the dialog (the default is 0 for each dimension). For example:

	  indy2 = DialogOptions.new do |d|
	    d.backtitle "Indiana Jones and the Temple of Doom"
	  end
	
	  indy3 = DialogOptions.new do |d|
	    d.backtitle "Indiana Jones and the Last Crusade"
	  end
	
	  # Use indy2 as the template for the dialog's options
	  Checklist.new(0,0,indy2) do |c|
	    c.title "Dinner menu"
	  end
	
	  Checklist.new(0,0,indy3) do |c|
	    c.title "Select a grail to drink from"
	  end

# Displaying a dialog object

As we've seem above, the simplest way to display a dialog is to invoke its
<tt>show!</tt> method. The <tt>show!</tt> method forks off the dialog program
(using the configured options) and blocks until it terminates, that is, until
the user selects an option or the dialog times out. Let's repeat our earlier
example:

	  yn = Yesno.new do |d|
	    d.text "What... is your favourite colour?"
	    d.yes "Blue"
	    d.no "Yellow"
	  end
	  yn.show!    # Will block until "something" happens

This is fine for most types of dialogs. What, however if we need to do some
processing while the dialog is being displayed? For example, if we intend to
use a Gauge (or some other dialog type) as a progress indicator. For these
moments there is the +show+ method. Like the <tt>show!</tt> method, +show+
forks off the dialog program to display the dialog. It does not, however,
block the caller. The dialog program executes in parallel with the main
process. We can wait for the termination of the dialog program by using the
+wait+ method:

	  yn = Yesno.new do |d|
	    d.text "What... is your favourite colour?"
	    d.yes "Blue"
	    d.no "Yellow"
	  end
	
	  yn.show
	  # Do some parallel processing
	  # ...  
	  yn.wait  # Wait for the dialog's completion

Note, that things like the predicate methods, etc. will only work after
waiting for the dialog's completion. Also note, that you must not invoke
another dialog (using neither +show+ nor <tt>show!</tt>) before having waited
for the completion of the current one. A few dialog types (most notably
+Gauge+ and the +Tailbox+ family) support updating the dialog. Let's look at a
complete (yet totally useless) example:

	  gauge = Gauge.new do |g|
	    g.text "Please wait... magic in progress"
	    g.complete 0.1
	  end
	  gauge.show
	
	  10.step(100, 10) do |v|
	    gauge.complete v
	    sleep 0.05
	  end
	  gauge.wait

First, we create a gauge and display it using the +show+ method. This allows
us to "process" the loop in parallel to displaying the dialog. In each step,
we update the gauge's status using the +complete+ method. After we are
finished, we make sure to wait for the termination of the dialog process by
using the +wait+ method.

# Knowing what the user selected

When using a more complex dialog type (a menu for example) it is not enough to
know which button the user pressed. We also need to know which menu item was
selected when the user exited the dialog. The dialog program outputs this
information on standard output in a format specific to the individual dialog
type. For example, when using a menu, dialog prints the tag of the selected
menu item. Check out the man page of dialog(1) for information on the output
formats.

After displaying a dialog, the output of the dialog program is available using
the +output+ method. Let's turn our Monty Python example into a menu to
demonstrate this:

	  menu = Menu.new do |m|
	    m.text "What... is your favourite colour?"
	    m.choice "blue", "Blue"
	    m.choice "yellow", "Yellow"
	  end
	  menu.show!
	
	  if menu.yes? && menu.output == "blue"
	    puts "Go on. Off you go."
	  else
	    puts "auuuuuuuugh."
	    exit
	  end

Right now, the dialog gem does not offer help in parsing the output. It may do
so in future versions.

# Using blocks a event handlers

Okay, we know how to initialize and display dialogs and how to find out what
the user selected. What's more? A more ruby-like way of dealing with user
input! Using lots of if-statements checking predicates like <tt>yes?</tt> to
attach program logic to user input is awkward.

As a more ruby-like way of doing things, methods like +yes+, +no+, +ok+,
+cancel+ (all methods for defining dialog buttons) accept an optional
block. This block is invoked when the user exits the dialog by selecting the
button the handler is attached to. The block is given two arguments: The
dialog object that invoked the block and, as a convenience, the dialog's
output. So our example from above becomes:

	  menu = Menu.new do |m|
	    m.text "What... is your favourite colour?"
	    m.choice "blue", "Blue"
	    m.choice "yellow", "Yellow"
	
	    m.no { |dialog,out| puts "auuuuuuuugh." }
	    m.yes do |dialog,out|
	      if out == "blue"
	        puts "Go on. Off you go."
	      else
	        puts "auuuuuuuugh."
	        exit
	      end
	    end
	  end
	  menu.show!

# Availability and Portability

Both the dialog program and the ncurses library are installed by default on a
number of Linux distributions. A number of similar solutions (like newt &
whiptail) exist, but, arguably, ncurses and dialog are the most widely
supported tools. If dialog and/or ncurses are not installed on your system,
they usually can be using your favourite package manager, or built from
source.

Both ncurses and dialog have successfully been ported to a large number of
systems, including BSD, MacOS X and Windows. <em>Note, however, that the
dialog gem has only been tested on Linux so far and will most likely fail on
non-Unix systems</em>. The reason will probably be some small issue with wrong
pathnames or similar. Please report a bug (see below) if the dialog gem fails
to invoke the dialog program on your platform.

For more information, check out the homepages of
ncurses[http://invisible-island.net/ncurses/] and
dialog[http://invisible-island.net/dialog/], especially the ncurses
FAQ[http://invisible-island.net/ncurses/ncurses.faq.html]

# Known bugs

No unit tests.

# Support (aka Reporting bugs)

The dialog homepage is dialog.rubyforge.org. You can download all releases of
dialog from there, including the trunk from subversion. Please report bugs or
requests for enhancement to dialog's rubyforge
tracker[http://rubyforge.org/tracker/?group_id=2153]. If possible, please
submit patches. Patches should be generated by "diff -u" or "svn diff" and
state against which release/svn revision they were made.
