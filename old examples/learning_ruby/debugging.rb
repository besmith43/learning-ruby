# start script with ruby -r debug script_name.rb
#
# n - step to the next line of code
# disp var - displays value of variable
# b line # - break at that line and do the next command
# example b 13, enter, and disp min

a = [1,5,4,3,6,7,3,2]
min = a.max

for i in a
	if i < min
		min = i
	end
end

puts min
