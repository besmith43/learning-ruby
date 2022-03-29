require "./data"

class Dinosaur
  def self.match_attributes
    @match_attributes || []
  end

  def self.add_attribute(name, value)
    define_method(name) do
      value
    end
  end

  def self.match_on(attr_name, &block)
    method_name = "match_#{attr_name}"
    matcher = block || -> attr, value { attr == value ? 1 : 0 }

    define_method(method_name) do |value|
      attr = self.send(attr_name)
      matcher.call(attr, value)
    end

    @match_attributes = self.match_attributes << attr_name
  end

  def self.match_on_any(attr_name)
    self.match_on(attr_name) do |ours, theirs|
      (ours & theirs).size
    end
  end

  def self.match_on_at_least(attr_name, threshold)
    self.match_on(attr_name) do |_, value|
      value >= threshold ? 1 : 0
    end
  end

  def self.reject_if(pairs)
    pairs.each do |attr_name, reject|
      self.match_on(attr_name) do |_, value|
        reject == value ? -1 : 0
      end
    end
  end

  def initialize(data)
    data.each do |key, value|
      self.class.add_attribute(key, value)
    end
  end

  def match(other)
    attributes = self.class.match_attributes

    attributes.inject(0) do |score, attr|
      match_method = "match_#{attr}"

      if other.respond_to?(attr)
        value = other.send(attr)
        score += send(match_method, value)
      else
        score
      end
    end
  end
end

class Diplodocus < Dinosaur
  reject_if :diet => "carnivore"
  match_on :suborder
end

class TyrannosaurusRex < Dinosaur
  match_on_any :hobbies
end

trex = TyrannosaurusRex.new(TREX_DATA)
diplo = Diplodocus.new(DIPLODOCUS_DATA)

trex.match(diplo) # => 1
diplo.match(trex) # => -1
