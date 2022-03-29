class HomeController < ApplicationController
  def show
  	@pages = Page.where("featured = true")
  end
end
