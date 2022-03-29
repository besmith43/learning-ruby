#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.join(File.dirname(__FILE__), "spec_helper")

describe "Model attribute setters" do

  before(:each) do
    MODEL_DB.reset

    @c = Class.new(Sequel::Model(:items)) do
      def columns
        [:id, :x, :y]
      end
    end
  end

  it "should mark the column value as changed" do
    o = @c.new
    o.changed_columns.should == []

    o.x = 2
    o.changed_columns.should == [:x]

    o.y = 3
    o.changed_columns.should == [:x, :y]

    o.changed_columns.clear

    o[:x] = 2
    o.changed_columns.should == [:x]

    o[:y] = 3
    o.changed_columns.should == [:x, :y]
  end

end

describe "Model#serialize" do

  before(:each) do
    MODEL_DB.reset
  end

  it "should translate values to YAML when creating records" do
    @c = Class.new(Sequel::Model(:items)) do
      no_primary_key
      serialize :abc
    end

    @c.create(:abc => 1)
    @c.create(:abc => "hello")

    MODEL_DB.sqls.should == [ \
      "INSERT INTO items (abc) VALUES ('--- 1\n')", \
      "INSERT INTO items (abc) VALUES ('--- hello\n')", \
    ]
  end

  it "should support calling after the class is defined" do
    @c = Class.new(Sequel::Model(:items)) do
      no_primary_key
    end

    @c.serialize :def

    @c.create(:def => 1)
    @c.create(:def => "hello")

    MODEL_DB.sqls.should == [ \
      "INSERT INTO items (def) VALUES ('--- 1\n')", \
      "INSERT INTO items (def) VALUES ('--- hello\n')", \
    ]
  end

  it "should support using the Marshal format" do
    @c = Class.new(Sequel::Model(:items)) do
      no_primary_key
      serialize :abc, :format => :marshal
    end

    @c.create(:abc => 1)
    @c.create(:abc => "hello")

    MODEL_DB.sqls.should == [ \
      "INSERT INTO items (abc) VALUES ('BAhpBg==\n')", \
      "INSERT INTO items (abc) VALUES ('BAgiCmhlbGxv\n')", \
    ]
  end

  it "should translate values to and from YAML using accessor methods" do
    @c = Class.new(Sequel::Model(:items)) do
      serialize :abc, :def
    end

    ds = @c.dataset
    ds.extend(Module.new {
      attr_accessor :raw

      def fetch_rows(sql, &block)
        block.call(@raw)
      end

      @@sqls = nil

      def insert(*args)
        @@sqls = insert_sql(*args)
      end

      def update(*args)
        @@sqls = update_sql(*args)
      end

      def sqls
        @@sqls
      end

      def columns
        [:id, :abc, :def]
      end
    }
    )

    ds.raw = {:id => 1, :abc => "--- 1\n", :def => "--- hello\n"}
    o = @c.first
    o.id.should == 1
    o.abc.should == 1
    o.def.should == "hello"

    o.set(:abc => 23)
    ds.sqls.should == "UPDATE items SET abc = '#{23.to_yaml}' WHERE (id = 1)"

    ds.raw = {:id => 1, :abc => "--- 1\n", :def => "--- hello\n"}
    o = @c.create(:abc => [1, 2, 3])
    ds.sqls.should == "INSERT INTO items (abc) VALUES ('#{[1, 2, 3].to_yaml}')"
  end

end

describe Sequel::Model, "super_dataset" do
  setup do
    MODEL_DB.reset
    class SubClass < Sequel::Model(:items) ; end
  end
  
  it "should call the superclass's dataset" do
    SubClass.should_receive(:superclass).exactly(3).times.and_return(Sequel::Model(:items))
    Sequel::Model(:items).should_receive(:dataset)
    SubClass.super_dataset
  end
end

describe Sequel::Model, "dataset" do
  setup do
    @a = Class.new(Sequel::Model(:items))
    @b = Class.new(Sequel::Model)
    
    class Elephant < Sequel::Model(:ele1)
    end
    
    class Maggot < Sequel::Model
    end

    class ShoeSize < Sequel::Model
    end
    
    class BootSize < ShoeSize
    end
  end
  
  specify "should default to the plural of the class name" do
    Maggot.dataset.sql.should == 'SELECT * FROM maggots'
    ShoeSize.dataset.sql.should == 'SELECT * FROM shoe_sizes'
  end
  
  specify "should return the dataset for the superclass if available" do
    BootSize.dataset.sql.should == 'SELECT * FROM shoe_sizes'
  end
  
  specify "should return the correct dataset if set explicitly" do
    Elephant.dataset.sql.should == 'SELECT * FROM ele1'
    @a.dataset.sql.should == 'SELECT * FROM items'
  end
  
  specify "should raise if no dataset is explicitly set and the class is anonymous" do
    proc {@b.dataset}.should raise_error(Sequel::Error)
  end
  
  specify "should disregard namespaces for the table name" do
    module BlahBlah
      class MwaHaHa < Sequel::Model
      end
    end
    
    BlahBlah::MwaHaHa.dataset.sql.should == 'SELECT * FROM mwa_ha_has'
  end
end

describe "A model class with implicit table name" do
  setup do
    class Donkey < Sequel::Model
    end
  end
  
  specify "should have a dataset associated with the model class" do
    Donkey.dataset.model_classes.should == {nil => Donkey}
  end
end

describe "A model inheriting from a model" do
  setup do
    class Feline < Sequel::Model
    end
    
    class Leopard < Feline
    end
  end
  
  specify "should have a dataset associated with itself" do
    Feline.dataset.model_classes.should == {nil => Feline}
    Leopard.dataset.model_classes.should == {nil => Leopard}
  end
end

describe "Model.db=" do
  setup do
    $db1 = Sequel::Database.new
    $db2 = Sequel::Database.new
    
    class BlueBlue < Sequel::Model
      set_dataset $db1[:blue]
    end
  end
  
  specify "should affect the underlying dataset" do
    BlueBlue.db = $db2
    
    BlueBlue.dataset.db.should === $db2
    BlueBlue.dataset.db.should_not === $db1
  end
end

