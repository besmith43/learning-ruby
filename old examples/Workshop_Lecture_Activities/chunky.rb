require 'chunky_png'

png = ChunkyPNG::Image.new 32,32

32.times do |x|

32.times do |y|

color = ['red', 'green', 'blue'].sample

png[x,y] = ChunkyPNG::Color(color)

end

end

png.save 'random.png'
