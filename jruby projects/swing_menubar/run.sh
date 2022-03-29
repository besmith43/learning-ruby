#!/bin/bash

rubocop jar-bootstrap.rb ./lib/swing_menubar.rb ./lib/java_imports.rb

jar -uf swing_menubar.jar version.txt lib/

java -jar swing_menubar.jar
