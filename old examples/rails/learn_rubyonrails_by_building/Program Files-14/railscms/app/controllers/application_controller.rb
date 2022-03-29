class ApplicationController < ActionController::Base
	before_filter :getPageNav, :getJumbotron, :getBlocks
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def getPageNav
  	@pageNav = Page.where("menu_display = true && is_published = true").order(order: :asc)
  end

  def getJumbotron
  	@jumbotron = Block.where("position = 'jumbotron'")
  end

  def getBlocks
  	@blocks = Block.where("position = 'block'").order(order: :asc)
  end
end
