#!/usr/bin/env ruby
$: << "#{File.dirname(__FILE__)}/../config"
$PROFILING = false

require 'rubygems'
require 'rubygame'
include Rubygame

if $PROFILING
  require "ruby-prof"
end

#alias :orig_puts :puts
#def puts(it)
#  orig_puts "==============="
#  caller.each do |c|
#    orig_puts c
#  end
#  sleep 2
#end

require "environment"
require 'metaclass'
require 'publisher'
require 'constructor'
require 'diy'
require 'linked_list'

require 'resource_manager'
require 'input_manager'
require 'mouse_manager'
require 'sound_manager'
require 'network_manager'
require 'turn_manager'
require 'game_client'
require 'viewport'
require 'colors'
include Colors

class SnelpsApp

  def initialize()
    @context = DIY::Context.from_file(APP_ROOT + '/src/objects.yml')
  end
  
  def setup()
    # create game server (for now)
    Rubygame.init
    @client = @context[:game_client]
    RubyProf.start if $PROFILING
  end
  
  def main_loop()
    @input_manager = @context[:input_manager] 
    @input_manager.main_loop @client
  end

  def shutdown()
    if $PROFILING
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT, 0)
    end

    Rubygame.quit
  end

  def run()
    setup

    main_loop

    shutdown
  end
end

console = false

if ARGV[0] == 'console'
  console = true
end

if $0 == __FILE__
  app = SnelpsApp.new
  if console
    require 'drb'
    DRb.start_service("druby://:7777", app)
  end
  app.run
end
