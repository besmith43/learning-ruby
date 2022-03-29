#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.join(File.dirname(__FILE__), 'spec_helper')

describe Inflector do
  it "should transform words from singular to plural" do
    "post".pluralize.should == "posts"
    "octopus".pluralize.should =="octopi"
    "the blue mailman".pluralize.should == "the blue mailmen"
    "CamelOctopus".pluralize.should == "CamelOctopi"
  end
  
  it "should transform words from plural to singular" do
    "posts".singularize.should == "post"
    "octopi".singularize.should == "octopus"
    "the blue mailmen".singularize.should == "the blue mailman"
    "CamelOctopi".singularize.should == "CamelOctopus"
  end
  
  it "should transform class names to table names" do
    "RawScaledScorer".tableize.should == "raw_scaled_scorers"
    "egg_and_ham".tableize.should == "egg_and_hams"
    "fancyCategory".tableize.should == "fancy_categories"
  end
  
  it "should tranform table names to class names" do
    "egg_and_hams".classify.should == "EggAndHam"
    "post".classify.should == "Post"
  end
  
  it "should create a foreign key name from a class name" do
    "Message".foreign_key.should == "message_id"
    "Message".foreign_key(false).should == "messageid"
    "Admin::Post".foreign_key.should == "post_id"
  end
end