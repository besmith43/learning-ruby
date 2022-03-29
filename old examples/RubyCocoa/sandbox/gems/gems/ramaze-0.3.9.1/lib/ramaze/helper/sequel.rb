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
  module Helper::Sequel
    def paginator(paginated, target)
      page_count = paginated.page_count
      prev_page = paginated.prev_page
      current_page = paginated.current_page
      next_page = paginated.next_page

      lower = (current_page - 3).abs
      lower = lower == 0 ? 1 : lower

      out = ['<div class="paginator">']

      if prev_page
        out << %(<a class="paginator_prev" href="#{Rs(target, prev_page)}">&lt;&nbsp;Prev</a>)
      else
        out << %(<span class="paginator_prev">&lt;&nbsp;Prev</span>)
      end

      if current_page > 3
        out << %(<a class="paginator_page" href="#{Rs(target, 1)}">#{1}</a> ... )
      end

      lower.upto(current_page) do |pc|
        next if pc == current_page
        out << %(<a class="paginator_page" href="#{Rs(target, pc)}">#{pc}</a>)
      end

      out << %(<span class="paginator_current">#{current_page}</span>)

      current_page.upto([page_count, current_page + 3].min) do |pc|
        next if pc == current_page
        out << %(<a class="paginator_page" href="#{Rs(target, pc)}">#{pc}</a>)
      end

      if current_page < (page_count - 3)
        out << %(.. <a class="paginator_page" href="#{Rs(target, page_count)}">#{page_count}</a>)
      end

      if next_page
        out << %(<a class="paginator_next" href="#{Rs(target, next_page)}">Next&nbsp;&gt;</a>)
      else
        out << %(<span class="paginator_next">Next&nbsp;&gt;</span>)
      end
      out << '</div>'
      out.join(" ")
    end
  end
end
