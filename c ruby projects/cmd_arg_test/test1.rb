require 'optparse'

# this example came from the following link:
# https://ruby-doc.org/stdlib-3.1.0/libdoc/optparse/rdoc/OptionParser.html

Options = Struct.new(:name)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |parser|
      parser.banner = "Usage: example.rb [options]"

      parser.on("-nNAME", "--name=NAME", "Name to say hello to") do |n|
        args.name = n
      end

      parser.on("-h", "--help", "Prints this help") do
        puts parser
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

options = Parser.parse %w[--help]
