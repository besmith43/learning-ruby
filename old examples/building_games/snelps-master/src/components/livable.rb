module Livable

  attr_accessor :alive
  def self.included(target)
    target.add_setup_listener :setup_livable
    target.can_fire :death
  end

  def setup_livable(args)
    require_components :audible
    @alive = true
  end

  def damage(amount)
    self.health -= amount
    die if self.health < 1
  end

  def die()
    if @alive
      @alive = false
      death_sound
      fire :death, self 
      self.destroy
    end
  end

  def alive?
    @alive
  end


end
