#!/usr/bin/env ruby

require 'rubygems'
require "newt"

Newt::Screen.new

Newt::Screen.init
Newt::Screen.cls

cols, rows = Newt::Screen.size

Newt::Screen.finish

p cols, rows
