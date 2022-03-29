# Sample code from Programing Ruby, page 257
require 'win32ole'

$urls = []

def navigate(url)
  $urls << url
end

def stop_msg_loop
  puts "IE has exited..."
  throw :done
end

def default_handler(event, *args)
  case event
  when "BeforeNavigate"
    puts "Now Navigating to #{args[0]}..."
  end
end

ie = WIN32OLE.new('InternetExplorer.Application')
ie.visible = TRUE
ie.gohome
ev = WIN32OLE_EVENT.new(ie, 'DWebBrowserEvents')

ev.on_event {|*args| default_handler(*args)}
ev.on_event("NavigateComplete") {|url| navigate(url)}
ev.on_event("Quit") {|*args| stop_msg_loop} 

catch(:done) do
  loop do
    WIN32OLE_EVENT.message_loop
  end
end

puts "You Navigated to the following URLs: "
$urls.each_with_index do |url, i|
  puts "(#{i+1}) #{url}"
end
