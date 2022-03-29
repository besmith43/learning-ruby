def reverseParentheses(s)
	count = 0
	puts "starting function"
    while s.include? "("
		count += 1
		puts "beginning while loop with #{s}"
		start = s.index "("
		puts "opening parentheses at #{start}"
		finish = s.rindex ")"
		puts "closing parentheses at #{finish}"
							    
		before = s[0..(start-1)]
		puts "before is #{before}"
		after = s[(finish+1)..(s.length-1)]
		puts "after is #{after}"
											    
		start += 1
		finish -= 1
															    
		new_s = s[start..finish]
		new_s.reverse!
		puts "reversed inner string is #{new_s}"
																			    
		s = before + new_s + after
		puts "final string of while loop is #{s}"
		if count > 2
			return s
		end
	end
		        
	return s
end

s = "a(bcdefghijkl(mno)p)q"

s1 = reverseParentheses(s)

p s1
