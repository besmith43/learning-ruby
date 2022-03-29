class Class2
  def hello
    puts "hello from class 2"
  end
end

if __FILE__ == $PROGRAM_NAME
  thing2 = Class2.new
  thing2.hello
end
