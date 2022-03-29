#!/bin/bash

# to compile ruby files into java class files, run jrubyc $script_file
# to install gems, run jruby -S gem install $gem

program=$1

java -cp :jruby.jar $program
