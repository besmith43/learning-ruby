def reverseParentheses(s)
  s1 = s.count "("
  s2 = s.count ")"
    if s1 == 0 and s2 == 0
        return s
    elsif s1 == 1 and s2 == 1
        start = s.index "("
        finish = s.rindex ")"

        before = s[0..(start-1)]
        after = s[(finish+1)..(s.length-1)]

        start += 1
        finish -= 1

        new_s = s[start..finish]
        new_s.reverse!

        s = before + new_s + after
    else
        start = s.index "("
        finish = s.rindex ")"

        before = s[0..(start-1)]
        after = s[(finish+1)..(s.length-1)]

        start += 1
        finish -= 1

        new_s = s[start..finish]

        new_s = reverseParentheses(new_s)

        s = before + new_s + after
    end
end

s = "a(bcdefghijkl(mno)p)q"

s1 = reverseParentheses(s)

p s1
