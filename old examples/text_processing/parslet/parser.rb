#---
# Excerpted from "Text Processing with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rmtpruby for more book information.
#---
require "parslet"

class ConfigParser < Parslet::Parser
  rule(:name) { match("\\w").repeat(1).as(:name) }

  rule(:whitespace) { match("[ \\t]").repeat(1) }
  rule(:assignment) { whitespace.maybe >> str("=") >> whitespace.maybe }

  rule(:newline) { str("\n") | str("\r\n") }
  rule(:value) {
    str('"') >>
    (str('"').absent? >> any).repeat.as(:string) >>
    str('"')
  }

  rule(:item) { name >> assignment >> value.as(:value) >> newline }

  rule(:document) { (item.repeat).as(:document) >> newline.repeat }

  root :document
end

config = ConfigParser.new.parse(File.read("config.txt"))
# => {:document=>
#      [{:name=>"name"@0, :value=>{:string=>"Alice’s website"@8}},
#       {:name=>"description"@25,
#        :value=>{:string=>"Alice's personal blog"@40}},
#       {:name=>"url"@63, :value=>{:string=>"http://alice.example.com/"@70}},
#       {:name=>"public"@97, :value=>{:string=>"true"@107}},
#       {:name=>"version"@113, :value=>{:string=>"24"@124}}]}

class ConfigToHash < Parslet::Transform
  rule(string: simple(:s)) {
    case s
    when "true"
      true
    when "false"
      false
    when /\A[0-9]+\z/
      Integer(s)
    else
      String(s)
    end
  }

  rule(name: simple(:n), value: simple(:v)) { [String(n), v] }
  rule(document: subtree(:i)) { i.to_h }
end

def parse_config(config_file)
  parsed = ConfigParser.new.parse(File.read(config_file))
  config = ConfigToHash.new.apply(parsed)

  config
end

config = parse_config("config.txt")
# => {"name"=>"Alice’s website",
#     "description"=>"Alice's personal blog",
#     "url"=>"http://alice.example.com/",
#     "public"=>true,
#     "version"=>24}

