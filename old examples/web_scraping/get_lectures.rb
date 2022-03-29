#!/usr/bin/env ruby

require 'webinspector'
require 'csv'
require 'shell'

main_url = 'http://mboshart.dyndns.org/~mboshart/3410examples.html'
page = WebInspector.new(main_url)
description = page.description
links = page.links
download_links = []
append = "/media/video.mp4"
file_extension = ".mp4"
class_with_section = "CSC_3410-00"
filenames = []


links.each do |link|
	if link.include?("2017")
		filename = ""
		if link.include?(class_with_section)
			start_index = 46
		else
			start_index = 42
		end
		end_index = link.rindex("-")
		link_date = link.slice(start_index..end_index-2)
		first_space_index = link_date.index("_")
		second_space_index = link_date.rindex("_")
		link_date[first_space_index] = " "
		link_date[second_space_index] = ","
		link_date.insert(second_space_index+1, " ")
		description.each_line do |line|
			if line.include?(link_date)
				if !filenames.include?(link)
					line.chomp!('')
					line.slice!(0..8)
					line.gsub!(/\s+/, "")
					filenames << line
					filename = line + file_extension
					break
				end
			end
		end
		end_length = link.length
		new_end_length = end_length - 5
		link.slice!(new_end_length..end_length)
		link = link + append
		download_links << link
		system "wget #{link} -O #{filename}"
	end
end


