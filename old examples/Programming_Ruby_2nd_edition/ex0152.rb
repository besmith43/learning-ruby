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
show_regexp('banana', /an*/)
show_regexp('banana', /(an)*/)
show_regexp('banana', /(an)+/)
