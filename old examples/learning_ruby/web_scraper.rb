require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

page = HTTParty.get('https://www.docker.com/what-docker')

parse_page = Nokogiri::HTML(page)

test_array = []

parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
	post_name = a.text
	test_array.push(post_name)
end

CSV.open('test.csv', 'w') do |csv|
	csv << test_array
end

#Pry.start(binding)

