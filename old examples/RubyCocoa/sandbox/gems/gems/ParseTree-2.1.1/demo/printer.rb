#!/usr/local/bin/ruby -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'sexp_processor'

class QuickPrinter < SexpProcessor
  def initialize
    super
    self.strict = false
    self.auto_shift_type = true
  end
  def process_defn(exp)
    name = exp.shift
    args = process exp.shift
    body = process exp.shift
    puts "  def #{name}"
    return s(:defn, name, args, body)
  end
end

QuickPrinter.new.process(*ParseTree.new.parse_tree(QuickPrinter))
