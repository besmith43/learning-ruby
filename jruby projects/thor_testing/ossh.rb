#!/usr/bin/env ruby

require 'thor'

class Ossh < Thor
  def sound()
    puts "you choose to connect to NerdSound"
  end

  def compute()
    puts "you choose to connect to NerdCompute"
  end
end

Ossh.start(ARGV)
