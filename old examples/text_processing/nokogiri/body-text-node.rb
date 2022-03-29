#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "nokogiri"

doc = Nokogiri::HTML(<<-DOC)
<html>
<body>
  Some body text

  <p>Some paragraph text</p>
</body>
</html>
DOC

doc.at_css("body text()").text
 # => "\n  Some body text\n\n  "

