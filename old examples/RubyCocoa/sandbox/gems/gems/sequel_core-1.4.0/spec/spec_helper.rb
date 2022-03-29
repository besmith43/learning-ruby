#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require File.join(File.dirname(__FILE__), "../lib/sequel_core") 

if File.exists?(File.join(File.dirname(__FILE__), 'spec_config.rb'))
  require File.join(File.dirname(__FILE__), 'spec_config.rb')
end

class MockDataset < Sequel::Dataset
  def insert(*args)
    @db.execute insert_sql(*args)
  end
  
  def update(*args)
    @db.execute update_sql(*args)
  end
  
  def fetch_rows(sql)
    @db.execute(sql)
    yield({:id => 1, :x => 1})
  end
end

class MockDatabase < Sequel::Database
  attr_reader :sqls
  
  def execute(sql)
    @sqls ||= []
    @sqls << sql
  end

  def reset
    @sqls = []
  end

  def transaction; yield; end
  
  def dataset; MockDataset.new(self); end
end

class SchemaDummyDatabase < Sequel::Database
  attr_reader :sqls
  
  def execute(sql)
    @sqls ||= []
    @sqls << sql
  end
end

