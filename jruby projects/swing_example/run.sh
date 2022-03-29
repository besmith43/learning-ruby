#!/bin/bash

echo "-------------------------- example 1 -------------------------------"

jrubyc example.rb

jar --create --file example1.jar --manifest manifest.txt example.class jruby.jar

echo "example 1 is built by compiling ruby to class file and putting that in a jar"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example1.jar

rm example.class

echo "-------------------------- example 2 -------------------------------"

cp example.rb jar-bootstrap.rb

jar ufe example2.jar org.jruby.JarBootstrapMain jar-bootstrap.rb

echo "example 2 is built by overriding the original bootstrap script in a basic jruby.jar"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example2.jar

echo "-------------------------- example 3 -------------------------------"

mkdir bin

cp example.rb bin/example.rb

warble jar

mv swing_example.jar example3.jar

rm -r bin

echo "example 3 is built by warbler gem"

java --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED -jar example3.jar


