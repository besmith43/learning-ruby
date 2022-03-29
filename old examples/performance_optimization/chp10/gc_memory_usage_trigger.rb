#---
# Excerpted from "Ruby Performance Optimization",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/adrpo for more book information.
#---
data = "x"*1024*1024*10; nil
# store in array to keep data from garbage collection
buffers = []
GC.start
GC.stat[:count]
10.times do |i|
  buffers[i] = data.dup
  # actually force Ruby to copy data in the memory
  buffers[i][0] = 'a'
end; nil
GC.stat[:count]
