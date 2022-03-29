class Person
  PEOPLE = []
  attr_reader :name, :hobbies, :friends
  def initialize(name)
    @name = name
    @hobbies = []
    @friends = []
    PEOPLE << self
  end

  def has_hobby(hobby)
    @hobbies << hobby
  end

  def has_friend(friend)
    @friends << friend
  end