HTML_FORMATTER = lambda do |context|
  puts '<html>'
  puts '  <head>'
  puts "    <title>#{context.title}</title>"
  puts '  </head>'
  puts '  <body>'
  context.text.each do |line|
    puts "    <p>#{line}</p>"
  end
  puts '  </body>'
  puts '</html>'
end
