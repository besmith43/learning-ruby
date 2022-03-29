#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
libdir = File.expand_path(File.join(File.dirname(__FILE__), '../../../'))
$LOAD_PATH.unshift libdir
require 'vendor/bacon'
require 'ramaze/spec/helper/pretty_output'
Bacon.extend Bacon::PrettyOutput
# Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit
