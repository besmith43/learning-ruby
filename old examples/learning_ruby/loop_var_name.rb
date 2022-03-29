 for i in 0..15 do
	   index_val = "some value #{i}"
	     instance_variable_set("@variable_#{i}", index_val)
 end

 puts @variable_4
