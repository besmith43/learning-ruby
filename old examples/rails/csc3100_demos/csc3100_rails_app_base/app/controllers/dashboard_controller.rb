class DashboardController < ApplicationController
  def index
  end

  def page1 # experiences
    @exp = Experience.where("owner = ?", current_user.id)
  end

  def page2
  end
end
