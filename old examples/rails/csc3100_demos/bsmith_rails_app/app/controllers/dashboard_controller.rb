class DashboardController < ApplicationController
  def index
  end

  def page1
  end

  def page2
    @user = User.find(current_user.id)
    @courses = Course.where("owner = ?", current_user.id)
  end
  
  def experience
    @work_experiences = WorkExperience.where("owner = ?", current_user.id)
  end
  
  def honors
    @honors_and_awards = HonorsAndAward.where("owner = ?", current_user.id)
  end
  
  def skills
    @skills_and_interests = SkillsAndInterest.where("owner = ?", current_user.id)
  end
  
  def references
    @references = Reference.where("owner = ?", current_user.id)
  end
end
