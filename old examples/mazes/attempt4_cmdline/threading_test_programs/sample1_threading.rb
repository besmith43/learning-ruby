require 'prime'
require 'pp'
require 'benchmark'

def find_prime(array)
	prime_array = []
	size = array.length
	(0..size-1).each do |x|
		temp = array[x]
		if Prime.instance.prime?(temp)
			prime_array << temp
		end
	end

	prime_array
end

def populate_array(start, finish, size)
	count = 0
	array = Array.new(size)
	(start..finish).each do |x|
		array[count] = x
		count += 1
	end

	array
end

t1 = Benchmark.realtime do
	single_thread = populate_array(1, 10000000, 10000000)
	single_thread_primes = find_prime(single_thread)
end

t2 = Benchmark.realtime do
	q1 = populate_array(1, 2500000, 2500000)
	q2 = populate_array(2500001, 5000000, 2500000)
	q3 = populate_array(5000001, 7500000, 2500000)
	q4 = populate_array(7500001, 10000000, 2500000)

	master = []
	prime_master = []
	threads = []

	master << q1
	master << q2
	master << q3
	master << q4

	for array in master
		threads << Thread.new(array) { |myArray|
			prime_array = find_prime(myArray)
			prime_master << prime_array
		}
	end

	threads.each { |aThread| aThread.join }
end

puts ""
puts "Single Threaded Time"
puts t1
puts ""
puts "Multi-Threaded Time"
puts t2
