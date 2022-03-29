class Class1
  def hello
    puts "hello from class 1"
  end
end

if __FILE__ == $PROGRAM_NAME
  thing1 = Class1.new
  thing1.hello
end
