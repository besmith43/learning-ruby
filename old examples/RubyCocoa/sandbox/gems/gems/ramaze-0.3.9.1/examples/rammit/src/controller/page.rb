#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class PageController < Ramaze::Controller
  map '/page'

  def create
    redirect_referrer unless request.post?
    if text = request[:text]
      page = Page.create :text => text
      redirect page.url
    end
  end

  def view(oid)
    page = Page[oid]
    @text = page.text
  end
end
