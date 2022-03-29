print "Exit the program? (yes or no): "
answer = gets.chomp
case answer
when "yes"
  puts "Good-bye!"
  exit
when "no"
  puts "OK, we'll continue"
else
  puts "That's an unknown answer -- assuming you meant 'no'"
end
puts "Continuing with program...."