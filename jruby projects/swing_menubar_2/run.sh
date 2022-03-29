#!/bin/bash

rubocop swing_menubar.rb java_imports.rb

#jar -uf swing_menubar.jar version.txt lib/

jrubyc swing_menubar.rb

jar --create --file example.jar --manifest manifest.txt swing_menubar.class jruby.jar optionparser.rb ostruct.rb optparse.rb optparse/

java -jar example.jar --title "running from build script"
