#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.join(File.dirname(__FILE__), 'spec_helper')

context "Time calculations" do
  specify "should support conversion of minutes to seconds" do
    1.minute.should == 60
    3.minutes.should == 180
  end
  
  specify "should support conversion of hours to seconds" do
    1.hour.should == 3600
    3.hours.should == 3600 * 3
  end

  specify "should support conversion of days to seconds" do
    1.day.should == 86400
    3.days.should == 86400 * 3
  end

  specify "should support conversion of weeks to seconds" do
    1.week.should == 86400 * 7
    3.weeks.should == 86400 * 7 * 3
  end
  
  specify "should provide #ago functionality" do
    t1 = Time.now
    t2 = 1.day.ago
    t1.should > t2
    ((t1 - t2).to_i - 86400).abs.should < 2
    
    t1 = Time.now
    t2 = 1.day.before(t1)
    t2.should == t1 - 1.day
  end

  specify "should provide #from_now functionality" do
    t1 = Time.now
    t2 = 1.day.from_now
    t1.should < t2
    ((t2 - t1).to_i - 86400).abs.should < 2
    
    t1 = Time.now
    t2 = 1.day.since(t1)
    t2.should == t1 + 1.day
  end
end