#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.join(File.dirname(__FILE__), "spec_helper")

describe Sequel::Model, "one_to_one" do

  before(:each) do
    MODEL_DB.reset

    @c1 = Class.new(Sequel::Model(:attributes)) do
    end

    @c2 = Class.new(Sequel::Model(:nodes)) do
      def columns; [:id, :parent_id]; end
    end

    @dataset = @c2.dataset

    @dataset.extend(Module.new {
      def fetch_rows(sql)
        @db << sql
        yield({:hey => 1})
      end
    })
  end

  it "should use implicit key if omitted" do
    @c2.one_to_one :parent, :from => @c2

    d = @c2.new(:id => 1, :parent_id => 234)
    p = d.parent
    p.class.should == @c2
    p.values.should == {:hey => 1}

    MODEL_DB.sqls.should == ["SELECT * FROM nodes WHERE (id = 234) LIMIT 1"]
  end

  it "should use explicit key if given" do
    @c2.one_to_one :parent, :from => @c2, :key => :blah

    d = @c2.new(:id => 1, :blah => 567)
    p = d.parent
    p.class.should == @c2
    p.values.should == {:hey => 1}

    MODEL_DB.sqls.should == ["SELECT * FROM nodes WHERE (id = 567) LIMIT 1"]
  end

  # the new implementation doesn't support plain datasets as associations
  # it "should support plain dataset in the from option" do
  #   @c2.one_to_one :parent, :from => MODEL_DB[:xyz]
  #   
  #   d = @c2.new(:id => 1, :parent_id => 789)
  #   p = d.parent
  #   p.class.should == Hash
  #   
  #   MODEL_DB.sqls.should == ["SELECT * FROM xyz WHERE (id = 789) LIMIT 1"]
  # end

  # the new implementation doesn't support plain datasets as associations
  # it "should support table name in the from option" do
  #   @c2.one_to_one :parent, :from => :abc
  # 
  #   d = @c2.new(:id => 1, :parent_id => 789)
  #   p = d.parent
  #   p.class.should == Hash
  # 
  #   MODEL_DB.sqls.should == ["SELECT * FROM abc WHERE (id = 789) LIMIT 1"]
  # end

  it "should return nil if key value is nil" do
    @c2.one_to_one :parent, :from => @c2

    d = @c2.new(:id => 1)
    d.parent.should == nil
  end

  it "should define a setter method" do
    @c2.one_to_one :parent, :from => @c2

    d = @c2.load(:id => 1)
    d.parent = @c2.new(:id => 4321)
    d.values.should == {:id => 1, :parent_id => 4321}
    d.save_changes
    MODEL_DB.sqls.last.should == "UPDATE nodes SET parent_id = 4321 WHERE (id = 1)"

    d.parent = nil
    d.values.should == {:id => 1, :parent_id => nil}
    d.save_changes
    MODEL_DB.sqls.last.should == "UPDATE nodes SET parent_id = NULL WHERE (id = 1)"

    e = @c2.new(:id => 6677)
    d.parent = e
    d.values.should == {:id => 1, :parent_id => 6677}
    d.save_changes
    MODEL_DB.sqls.last.should == "UPDATE nodes SET parent_id = 6677 WHERE (id = 1)"
  end
end

describe Sequel::Model, "one_to_many" do

  before(:each) do
    MODEL_DB.reset

    @c1 = Class.new(Sequel::Model(:attributes)) do
    end

    @c2 = Class.new(Sequel::Model(:nodes)) do
    end
  end

  it "should define a getter method" do
    @c2.one_to_many :attributes, :from => @c1, :key => :node_id

    n = @c2.new(:id => 1234)
    a = n.attributes_dataset
    a.should be_a_kind_of(Sequel::Dataset)
    a.sql.should == 'SELECT * FROM attributes WHERE (node_id = 1234)'
  end
  
  # the new implementation doesn't support plain datasets as associations
  # it "should support plain dataset in the from option" do
  #   @c2.one_to_many :attributes, :from => MODEL_DB[:xyz], :key => :node_id
  # 
  #   n = @c2.new(:id => 1234)
  #   a = n.attributes
  #   a.should be_a_kind_of(Sequel::Dataset)
  #   a.sql.should == 'SELECT * FROM xyz WHERE (node_id = 1234)'
  # end

  # the new implementation doesn't support plain datasets as associations
  # it "should support table name in the from option" do
  #   @c2.one_to_many :attributes, :from => :abc, :key => :node_id
  # 
  #   n = @c2.new(:id => 1234)
  #   a = n.attributes
  #   a.should be_a_kind_of(Sequel::Dataset)
  #   a.sql.should == 'SELECT * FROM abc WHERE (node_id = 1234)'
  # end
  
  it "should support implicit key names" do
    $c1 = @c1
    
    module Music
      class BlueNote < Sequel::Model
        one_to_many :attributes, :from => $c1
      end
    end
    
    n = Music::BlueNote.new(:id => 1234)
    a = n.attributes_dataset
    a.should be_a_kind_of(Sequel::Dataset)
    a.sql.should == 'SELECT * FROM attributes WHERE (blue_note_id = 1234)'
  end
end
