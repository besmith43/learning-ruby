require 'ruby-progressbar'

puts "Basic Progress Bar"

progressbar = ProgressBar.create

100.times { progressbar.increment; sleep 0.01 }

puts ""
puts ""

puts "Playing with Progress Bar Options"

adv_prog_bar = ProgressBar.create(:title => "Advanced Progress Bar Test", :total => 1000, format: 'Progress %c/%C |%b>%i| %a %e')

#adv_prog_bar.start
1000.times { adv_prog_bar.increment; sleep 0.01 }
#adv_prog_bar.stop


# Formatting Link
# https://github.com/jfelchner/ruby-progressbar/wiki/Formatting
