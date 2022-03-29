#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
ARGF.each do |line|
  case ARGF.file.lineno
  when 1
    puts "\n#{ARGF.filename}\n\n"
  when 6
    ARGF.skip
    next
  end

  puts line
end
