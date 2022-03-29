# Sample code from Programing Ruby, page 372
  class Module
    @@docs = {}

    # Invoked during class definitions
    def doc(str)
      @@docs[self.name] = self.name + ":\n" + str.gsub(/^\s+/, '')
    end
    
    # invoked to get documentation
    def Module::doc(aClass)
      # If we're passed a class or module, convert to string
      # ('<=' for classes checks for same class or subtype)
      aClass = aClass.name if aClass.class <= Module
      @@docs[aClass] || "No documentation for #{aClass}"
    end
  end

  class Example
    doc "This is a sample documentation string"
    # .. rest of class
  end

  module Another
    doc <<-edoc
      And this is a documentation string
      in a module
    edoc
    # rest of module
  end

  puts Module::doc(Example)
  puts Module::doc("Another")
