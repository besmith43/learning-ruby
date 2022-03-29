# Sample code from Programing Ruby, page 69
class String
 def inspect
  to_s
 end
end
def show_regexp(a, re)
  if a =~ re
    "#{$`}<<#{$&}>>#{$'}"
  else
    "no match"
  end
end
a = 'red ball blue sky'
show_regexp(a, /blue|red/)
show_regexp(a, /(blue|red) \w+/)
show_regexp(a, /(red|blue) \w+/)
show_regexp(a, /red|blue \w+/)
