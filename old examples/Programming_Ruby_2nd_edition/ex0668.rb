# Sample code from Programing Ruby, page 387
  class Demo
    @@var = 99
    CONST = 1.23

    private
      def private_method
      end
    protected
      def protected_method
      end
    public
      def public_method
        @inst = 1
        i = 1
        j = 2
        local_variables
      end

    def Demo.class_method
    end
  end

  Demo.private_instance_methods(false)
  Demo.protected_instance_methods(false)
  Demo.public_instance_methods(false)
  Demo.singleton_methods(false)
  Demo.class_variables
  Demo.constants - Demo.superclass.constants

  demo = Demo.new
  demo.instance_variables
  # Get 'public_method' to return its local variables
  # and set an instance variable
  demo.public_method
  demo.instance_variables
