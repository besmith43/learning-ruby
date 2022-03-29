require 'benchmark'
include Benchmark         # we need the CAPTION and FORMAT constants
n = 5000000
Benchmark.benchmark(CAPTION, 7, FORMAT, ">total:", ">avg:") do |x|
  tf = x.report("for:")   { for i in 1..n; a = "1"; end }
  tt = x.report("times:") { n.times do   ; a = "1"; end }
  tu = x.report("upto:")  { 1.upto(n) do ; a = "1"; end }
  [tf+tt+tu, (tf+tt+tu)/3]
end
