#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "strscan"

text = "Eggs, cheese, onion, potato, peas"
scanner = StringScanner.new(text)

items = []
loop do
  items << scanner.scan(/\w+/)
  if scanner.check(/,/)
    scanner.skip(/,\s*/)
  else
    break
  end
end

items
# => ["Eggs", "cheese", "onion", "potato", "peas"]
