# typed: strict
require_relative 'things'

thingies = Things.new

thingies.hello "Tester"

answer = thingies.add(5, 2)

puts answer
