#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'sequel'

DB = Sequel.sqlite

class User < Sequel::Model(:user)
  set_schema do
    primary_key :id

    text :nick
    text :password
    text :email
    time :created
  end
end

class Page < Sequel::Model(:page)
  include Ramaze::Helper::Link

  set_schema do
    primary_key :id

    text :text
  end

  def url
    R(PageController, :view, id)
  end

end

[ User, Page ].each do |model|
  model.create_table! unless model.table_exists?
end
