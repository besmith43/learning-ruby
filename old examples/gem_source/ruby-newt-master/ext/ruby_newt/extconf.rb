require 'mkmf'

dir_config('slang')
dir_config('newt')

have_library("slang", "SLsmg_refresh")
have_library("newt", "newtInit")

create_makefile("ruby_newt")
