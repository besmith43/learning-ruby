#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'sequel'

DB = Sequel("sqlite:///#{__DIR__}/../blog.db")

class Entry < Sequel::Model(:entry)
  set_schema do
    primary_key :id

    time :created
    time :updated
    text :title
    text :content
  end

  def self.add(title, content)
    create :title => title, :content => content,
      :created => Time.now, :updated => Time.now
  end

  def update(title = title, content = content)
    self.title, self.content, self.updated = title, content, Time.now
    save
  end
end

Entry.create_table! unless Entry.table_exists?

if Entry.empty?
  Entry.add 'Blog created', 'Exciting news today, this blog was created'
end
