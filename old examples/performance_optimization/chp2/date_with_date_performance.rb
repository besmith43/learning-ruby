#---
# Excerpted from "Ruby Performance Optimization",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/adrpo for more book information.
#---
require 'benchmark'
require 'rubygems'
require 'date/performance'

GC.disable

memory_before = `ps -o rss= -p #{Process.pid}`.to_i/1024

time = Benchmark.realtime do
  100000.times do
    Date.new(2014,5,1)
  end
end

memory_after = `ps -o rss= -p #{Process.pid}`.to_i/1024

puts "time: #{time}, memory: #{"%d MB" % (memory_after - memory_before)}"
