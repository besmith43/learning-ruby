def self.method_missing(m, *args)
  method = m.to_s
  if method.start_with?("all_with_")
    attr = method[9..-1]
    if self.public_method_defined?(attr)
      PEOPLE.find_all do |person|
        person.send(attr).include?(args[0])
      end
    else
      raise ArgumentError, "Can't find #{attr}"
    end
  else
  super
  end
end