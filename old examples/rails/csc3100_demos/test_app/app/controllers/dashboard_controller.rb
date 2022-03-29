class DashboardController < ApplicationController
  def index
  end

  def page1
  end

  def page2
  end

   def adoptable
  end

  def resources
  end

  def support
  end

  def lost_pets
    @lost_forms = LostForm.all
  end

  def found_pets
    @pet_forms = PetForm.where(pending = false)
  end

  def lost_form
  end

  def found_form
  end
end
