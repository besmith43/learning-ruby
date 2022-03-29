require 'tty-prompt'

# do not use in jruby

prompt = TTY::Prompt.new

prompt.no?("Do you hate Ruby?")

