#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'tmpdir'

require 'ramaze'
require 'sequel'
require 'uv'

Ramaze::Log.debug "Initializing UltraViolet..."

Uv.copy_files "xhtml", __DIR__/"public"
Uv.init_syntaxes

UV_PRIORITY_NAMES = %w[ ruby plain_text html css javascript yaml diff ]

STYLE = 'iplastic'

Ramaze::Log.debug "done."

DB = Sequel.sqlite

require 'model/paste'
require 'controller/paste'

Ramaze.start
