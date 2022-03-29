#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

module Ramaze

  # Gives you some context around a specific line in a file.
  # the size argument works in both directions + the actual line,
  # size = 2 gives you 5 lines of source, the returned array has the
  # following format.
  #   [
  #     line = [
  #              lineno           = Integer,
  #              line             = String,
  #              is_searched_line = (lineno == initial_lineno)
  #            ],
  #     ...,
  #     ...
  #   ]
  # Example:
  #  caller_lines('/usr/lib/ruby/1.8/debug.rb', 122, 2) # ->
  #   [
  #     [ 120, "  def check_suspend",                               false ],
  #     [ 121, "    return if Thread.critical",                     false ],
  #     [ 122, "    while (Thread.critical = true; @suspend_next)", true  ],
  #     [ 123, "      DEBUGGER__.waiting.push Thread.current",      false ],
  #     [ 124, "      @suspend_next = false",                       false ]
  #   ]

  def self.caller_lines(file, line, size = 4)
    return [[0, file, true]] if file == '(eval)'
    lines = File.readlines(File.expand_path(file)) rescue []
    current = line.to_i - 1

    first = current - size
    first = first < 0 ? 0 : first

    last = current + size
    last = last > lines.size ? lines.size : last

    log = lines[first..last] || []

    area = []

    log.each_with_index do |line, index|
      index = index + first + 1
      area << [index, line.chomp, index == current + 1]
    end

    area
  end
end
