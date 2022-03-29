#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "./parser"

class RtfToHtml < Parslet::Transform
  rule(int: simple(:n)) { Integer(n) }

  rule(text: simple(:t)) { String(t) }

  rule(red: simple(:r), green: simple(:g), blue: simple(:b)) {
    "rgb(#{r}, #{g}, #{b})"
  }

  rule(control_word: { word: simple(:_), delimiter: simple(:_) }) {
    ""
  }

  rule(control_word: { word: "line", delimiter: simple(:x) }) {
    "<br>"
  }

  rule(control_word: { word: "b", delimiter: simple(:_) }) {
    "<strong>"
  }

  rule(control_word: { word: "b", delimiter: "0" }) {
    "</strong>"
  }

  rule(control_word: { word: "cf", delimiter: simple(:n) }) {
    "<span class=\"cf-#{n}\">"
  }

  rule(colors: subtree(:c)) {
    html = "<style>\n"

    c.each_with_index do |c, n|
      html << ".cf-#{n + 1} { color: #{c} }\n"
      html << ".cb-#{n + 1} { background-color: #{c} }\n"
    end

    html << "</style>"

    html
  }

  rule(header: subtree(:h), document: subtree(:d)) {
    html = <<-HTML
<!DOCTYPE html>
<html>
<head>
  #{h[:color_table]}
</head>
<body>
  #{d.join("\n")}
</body>
</html>
    HTML
  }
end

rtf = Rtf.new
parsed = rtf.parse(File.read("colors.rtf"))
html = RtfToHtml.new.apply(parsed)

puts html
# >> <!DOCTYPE html>
# >> <html>
# >> <head>
# >>   <style>
# >> .cf-1 { color: rgb(0, 0, 0) }
# >> .cb-1 { background-color: rgb(0, 0, 0) }
# >> .cf-2 { color: rgb(255, 0, 0) }
# >> .cb-2 { background-color: rgb(255, 0, 0) }
# >> </style>
# >> </head>
# >> <body>
# >>   This is some normal text, formatted in black.
# >> <br>
# >> 
# >> 
# >> <span class="cf-2">
# >> 
# >> This is some more text, but this time it's colored red.
# >> <br>
# >> 
# >> 
# >> <span class="cf-1">
# >> 
# >> Finally, this text is back to the normal color, but is 
# >> <strong>
# >> bold
# >> </strong>
# >> .
# >> 
# >> </body>
# >> </html>
