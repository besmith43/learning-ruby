#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class MainController < Ramaze::Controller
  

  def index handle = "main"
    @handle = handle
    @entry = WikiEntry.new(handle)
    if @entry.exists?
      @text = EntryView.render(@entry.content)
      @history = @entry.history.map{|f|
        DateTime.strptime(File.basename(f, ".mkd"),
        "%Y-%m-%d_%H-%M-%S")
      }.join("<br />\n")
    else
      @text = "No Entry"
    end
  end

  def edit handle
    @handle = handle
    @entry = WikiEntry.new(handle)
    @text = @entry.content
  end

  def revert handle
    WikiEntry[handle].revert
    redirect Rs(handle)
  end

  def unrevert handle
    WikiEntry[handle].unrevert
    redirect Rs(handle)
  end

  def delete handle
    WikiEntry[handle].delete
    redirect_referer
  end

  def save
    redirect_referer unless request.post?
    handle = request['handle']
    entry = WikiEntry.new(handle)
    entry.save(request['text'])
    redirect Rs(:index, handle)
  end

  def html_layout
    @nodes = WikiEntry.titles.map{|f|
        name = File.basename(f)
        %[<a href="/#{name}">#{name}</a>]
      }.join("\n")
  end

  layout '/html_layout'
end
