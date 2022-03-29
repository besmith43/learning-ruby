#!/usr/bin/ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

BEGIN {
	$LOAD_PATH.unshift File::dirname(File::dirname( __FILE__ )) + "/lib"
	require 'linguistics'
}

Linguistics::use( :en )

# Just a fun little demo of the conjunction (junction, what's your) function.

MinObjects = 5
MaxObjects = 35
Objects = %w[
	butcher baker candlestick-maker
	mouse clock
	cat fiddle cow moon dog sport dish spoon
	tisket tasket
	jack jill hill pail crown
]

def randobjlist
	objs = []
	0.upto( rand(MaxObjects - MinObjects) + MinObjects ) do
		objs << Objects[ rand(Objects.nitems) - 1 ]
	end

	return objs
end


puts "Random object list:\n\t" +
	randobjlist().en.conjunction

