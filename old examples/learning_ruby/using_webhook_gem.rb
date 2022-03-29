require 'webhook'

code, message, body = Webhook.post('http.requestb.in', :name => 'Blake', :age => '27')

if code == 200
	puts "Success: #{body}"
else
	puts "Error (#{code}): #{message}\n#{body}"
end

