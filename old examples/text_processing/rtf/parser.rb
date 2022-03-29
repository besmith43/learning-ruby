#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "parslet"

class Rtf < Parslet::Parser
  rule(:space)           { str(" ") }
  rule(:hyphen)          { str("-") }
  rule(:integer)         { match["0-9"].repeat(1) }
  rule(:newline)         { str("\n") }
  rule(:slash)           { str("\\") }
  rule(:letter_sequence) { match["a-z"].repeat }

  rule(:special_chars)   { match["\\\\{}"] }

  rule(:unformatted_text) {
    ( special_chars.absent? >> any ).repeat(1).as(:text)
  }

  rule(:control_word) {
    (
      slash >>
        letter_sequence.as(:word) >>
        control_delimiter.maybe.as(:delimiter)
    ).as(:control_word)
  }
  rule(:control_delimiter) { space | ( hyphen.maybe >> integer ) | str(";") }

  rule(:group) {
    (
      str("{") >>
      newline.maybe >>
      content >>
      newline.maybe >>
      str("}") >>
      newline.maybe
    ).as(:group)
  }

  rule(:content) {
    (
      unformatted_text |
      control_word     |
      group
    ).repeat
  }

  rule(:header) {
    ( slash >> str("rtf") >> integer.maybe.as(:version) ).as(:rtf) >>
    ( slash >> letter_sequence.as(:charset) ) >>
    ( slash >> str("deff") >> integer.maybe).maybe.as(:deff) >>
    color_table.maybe.as(:color_table) >>
    newline.maybe
  }

  rule(:color_table) {
    newline.maybe >>
    str("{") >>
    (slash >> str("colortbl;")) >>
    color_definition.repeat(1).as(:colors) >>
    str("}") >>
    newline.maybe
  }
  rule(:color_definition) {
    slash >> str("red")   >> (integer.as(:int)).as(:red)   >>
    slash >> str("green") >> (integer.as(:int)).as(:green) >>
    slash >> str("blue")  >> (integer.as(:int)).as(:blue)  >>
    str(";")
  }

  rule(:file) {
    str("{") >>
    header.as(:header) >>
    content.as(:document) >>
    str("}") >>
    newline.maybe
  }

  root :file
end

rtf = Rtf.new
rtf.parse(File.read("colors.rtf"))
# => {:header=>
#      {:rtf=>{:version=>"1"@5},
#       :charset=>"ansi"@7,
#       :deff=>"\\deff0"@11,
#       :color_table=>
#        {:colors=>
#          [{:red=>{:int=>"0"@33},
#            :green=>{:int=>"0"@40},
#            :blue=>{:int=>"0"@46}},
#           {:red=>{:int=>"255"@52},
#            :green=>{:int=>"0"@61},
#            :blue=>{:int=>"0"@67}}]}},
#     :document=>
#      [{:text=>"This is some normal text, formatted in black."@71},
#       {:control_word=>{:word=>"line"@117, :delimiter=>nil}},
#       {:text=>"\n"@121},
#       {:control_word=>{:word=>"cf"@123, :delimiter=>"2"@125}},
#       {:text=>
#         "\nThis is some more text, but this time it's colored red."@126},
#       {:control_word=>{:word=>"line"@184, :delimiter=>nil}},
#       {:text=>"\n"@188},
#       {:control_word=>{:word=>"cf"@190, :delimiter=>"1"@192}},
#       {:text=>
#         "\nFinally, this text is back to the normal color, but is "@193},
#       {:control_word=>{:word=>"b"@251, :delimiter=>" "@252}},
#       {:text=>"bold"@253},
#       {:control_word=>{:word=>"b"@258, :delimiter=>"0"@259}},
#       {:text=>".\n"@260}]}
