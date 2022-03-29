require 'pp'

array = []

1000000.times.map { array.push(Random.rand(1000000)) }

array.sort!

#pp array
