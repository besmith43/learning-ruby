#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "strscan"

class Config
  def initialize(config_file)
    @config_data = File.read(config_file)
    @config = {}
    parse_file
  end

  def [](name)
    @config[name]
  end

  private

  def parse_file
    @scanner = StringScanner.new(@config_data)
    @line = 0

    until @scanner.eos?
      @line += 1
      parse_item
    end
  end

  class SyntaxError < StandardError; end

  def syntax_error
    SyntaxError.new("Syntax error on line #{@line} (pos. #{@scanner.pos})")
  end

  NAME = /[a-z]+/
  WHITESPACE = /\s+/

  def parse_item
    name = @scanner.scan(NAME)
    fail syntax_error unless name

    @scanner.skip(WHITESPACE)
    fail syntax_error unless @scanner.scan(/=/)
    @scanner.skip(WHITESPACE)

    quote = @scanner.scan(/"|'/)
    fail syntax_error unless quote

    value = @scanner.scan_until(/(?=#{quote})/)
    fail syntax_error unless value

    @scanner.scan(/#{quote}/)

    @config[name] = value

    @scanner.skip(WHITESPACE)
  end
end

config = Config.new("config.txt")
config["name"]
# => "Alice’s website"
config["url"]
# => "http://alice.example.com/"

