#!/usr/bin/env ruby

def printSomething()
	puts "This is a function"
end

def addAandB(a, b)
	result = a + b
	puts "The result is #{result}"
end

def addStuff(a, b)
	result = a + b
	result
end

printSomething()
addAandB(4, 9)
r = addStuff(2, 5)
puts r
