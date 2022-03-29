$val = 0

def add(n)
	$val+=n
end

def mul(n)
	$val *=n
end

def sub(n)
	$val -=n
end

def muladd(a,b)
	$val *=a
	$val +=b
end

def disp
	puts $val
end

require './assembly.rb'
