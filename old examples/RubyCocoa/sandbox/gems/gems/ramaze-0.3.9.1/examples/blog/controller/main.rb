#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class MainController < Ramaze::Controller
  layout '/layout'

  def index
    @entries = Entry.order(:created.DESC).all
  end

  def delete id
    entry = Entry[id]
    entry.delete
    redirect :/
  end

  def edit id
    @entry = Entry[id]
    redirect_referrer unless @entry
  end

  def create
    Entry.add(*request[:title, :content])
    redirect :/
  end

  def save
    redirect_referer unless  entry = Entry[request[:id]]
    entry.update(*request[:title, :content])
    redirect :/
  end
end
