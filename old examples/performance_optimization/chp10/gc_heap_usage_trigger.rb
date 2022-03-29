#---
# Excerpted from "Ruby Performance Optimization",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/adrpo for more book information.
#---
GC.start
GC.stat
x = Array.new(15000) { Object.new }; nil
GC.stat.select { |k,v| [:count, :heap_used].include?(k) }
x = nil
GC.stat.select { |k,v| [:count, :heap_used].include?(k) }
y = Array.new(15000) { Object.new }; nil
GC.stat.select { |k,v| [:count, :heap_used].include?(k) }
z = Array.new(15000) { Object.new }; nil
GC.stat.select { |k,v| [:count, :heap_used].include?(k) }
