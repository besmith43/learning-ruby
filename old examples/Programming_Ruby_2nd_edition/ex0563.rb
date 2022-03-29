# Sample code from Programing Ruby, page 316
  class Holder
    @@var = 99
    def Holder.var=(val)
      @@var = val
    end
    def var
      @@var
    end
  end

  @@var = "top level variable"

  a = Holder.new
  a.var
