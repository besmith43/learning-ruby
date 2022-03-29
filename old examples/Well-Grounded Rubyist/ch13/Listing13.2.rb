class Lister < BasicObject
  attr_reader :list
  def initialize
    @list = ""
    @level = 0
  end

  def indent(string)
    " " * @level + string.to_s
  end

  def method_missing(m, &block)
    @list << indent(m) + ":"
    @list << "\n"
    @level += 2
    @list << indent(yield(self)) if block
    @level -= 2
    @list << "\n"
    return ""
  end
end