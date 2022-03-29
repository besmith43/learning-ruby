#!/usr/bin/env ruby

require 'date'

arr = [1, 2, 3, 4]

arr.each do |i|
	puts "hello" * i
end

class User #class names must start with a capital letter

	def can_vote? #ends with a question mark when it returns a value that is true or false and must begin with a lower case letter 
		@age >= 18 # @ is used to start the name of a local instance variable
	end

	def initialize(date_of_birth, name)
		days_since_birth = Date.today - Date.parse(date_of_birth)
		@age = days_since_birth / 365
		@name = name
	end

	def name
		@name
	end

	def name=(name)
		@name = name # where @name is the local instance variable within the class and name is the string variable passed into the method
	end
end

john = User.new("2000-01-01", "John")

puts "#{john.can_vote?}"

blake = User.new("1990-08-28", "Blake")

puts "#{blake.can_vote?}"

# method conventions
# always start with a lowercase letter and _ in between words to help separate method names from class names
# do not use get_name to get the value of a local instance variable @name but rather name
# in the same vein to set a local instance variable one would use name= for the method naming scheme
# methods that return true or false end in a question mark
# also methods that do something destructive or unexpected will end in an exclaimation mark
# it is good practice to have a version of the same method without the exclaimation mark that does something safer


puts "#{arr}"
arr.select(&:even?)
puts "#{arr}"
arr.select!(&:even?)
puts "#{arr}"

								# rule of optional paramters is that you can have as many or as few as you like but they must be the first or the last parameters in your list
def greet(name, informal=false) # optional boolean variable that is assumed to be false when not given
	if informal
		puts "hi #{name}"
	else
		puts "Hello #{name}"
	end
end

greet("John")
greet("Jim", true)

def always_five # parameter paras. are optional for methods that take no input values
	5
end

puts "#{always_five}"



# this is how you would define a variable name so that you could pick and chose which of the default variables you want to name without having to specfy all other variables
def greet(name, informal: false, shout: false)
	greeting = if informal then "hi" else "Hello" end
	message = "#{greeting} #{name}"
	if shout
		message.upcase
	else
		message
	end
end

greet("John", shout: true)

# or we could set a named variable without giving it a default value

def greetings(name:)
	"Hello #{name}"
end

# the problem is that we now have to give it the variable name with the colon in the declaration

greetings(name: "John")

# greetings("John") this version of the greetings command throws an error that there is no arguments given when there is 1 expected


# by default the last value in a method is returned and the general use of the return keyword is viewed as a bad practice

# this is ok ruby code

class MyClass
	def odd_or_even(num)
		if num.odd?
			return "odd"
		else
			return "even"
		end
	end
end


# this is preferred ruby code design

class MyClass
	def odd_or_even(num)
		if num.odd?
			"odd"
		else
			"even"
		end
	end
end

# return is ideal for situations where you need to return from a method earlier than usual


# a dollar sign ($) at the beginning of a variable name is a global variable in ruby
# for example

$home = "America"




