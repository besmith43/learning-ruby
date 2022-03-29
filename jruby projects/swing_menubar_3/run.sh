#!/bin/bash

rubocop swing_menubar.rb java_imports.rb

#jar -uf swing_menubar.jar version.txt lib/

jrubyc swing_menubar.rb

jar --create --file example.jar --manifest manifest.txt swing_menubar.class jruby.jar jruby-stdlib-9.3.3.0.jar

echo "running jar with title argument"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example.jar --title "running from build script"
