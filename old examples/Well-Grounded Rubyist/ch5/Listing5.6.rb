class Car
  @@makes = []
  @@cars = {}
  @@total_count = 0
  attr_reader :make

  def self.total_count
    @@total_count
  end

  def self.add_make(make)
    unless @@makes.include?(make)
    @@makes << make
    @@cars[make] = 0
    end
  end

  def initialize(make)
    if @@makes.include?(make)
      puts "Creating a new #{make}!"
      @make = make
    @@cars[make] += 1
    @@total_count += 1
    else raise "No such make: #{make}."
    end
  end

  def make_mates
    @@cars[self.make]
  end
end