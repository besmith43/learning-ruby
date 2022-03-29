#!/bin/bash

jar -uf jruby.jar lib/

jar ufe jruby.jar org.jruby.JarBottstrapMain jar-bootstrap.rb
