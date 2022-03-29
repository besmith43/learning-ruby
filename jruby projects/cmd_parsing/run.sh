#!/bin/bash

rubocop example.rb

echo "-------------------------- example 1 -------------------------------"

jrubyc example.rb

jar --create --file example1.jar --manifest manifest.txt example.class jruby.jar jruby-stdlib-9.3.3.0.jar

echo "example 1 is built by compiling ruby to class file and putting that in a jar"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example1.jar --title "running example 1"

echo "-------------------------- example 2 -------------------------------"

awk '{sub(/require/,"require_relative"); print}' example.rb > ./lib/example.rb

sed -i '' 's/optparse/\.\/optparse.rb/' ./lib/example.rb
sed -i '' 's/ostruct/\.\/ostruct.rb/' ./lib/example.rb

jar ufe example2.jar org.jruby.JarBootstrapMain jar-bootstrap.rb

jar -uf example2.jar lib/

echo "example 2 is built by overriding the original bootstrap script in a basic jruby.jar"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example2.jar --title "running example 2"

echo "-------------------------- example 3 -------------------------------"

mkdir bin

cp example.rb bin/example.rb

warble jar

mv cmd_parsing.jar example3.jar

rm -r bin

echo "example 3 is built by warbler gem"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example3.jar --title "running example 3"


