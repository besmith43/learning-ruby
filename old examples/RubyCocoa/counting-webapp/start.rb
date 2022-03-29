#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require '../sandbox'

require 'rubygems'
require 'ramaze'
require 'sequel'
require 'fenestration'


DB = Sequel.sqlite  # in-memory database

class User < Sequel::Model
  set_schema do
    primary_key :id
    text :name, :null => false
    integer :creations, :default => 0 
    integer :views, :default => 0
  end
end
User.create_table unless User.table_exists?


class MainController < Ramaze::Controller
  layout :layout

  def index
    @names = User.map(:name)
  end

  def create
    name = request['name']

    @user = User[:name => name]
    if @user
      flash[:notice] = "User #{@user.name} already exists."
    else 
      @user = User.create(:name => name)
    end
    @user.creations += 1
    @user.save
    redirect('/')
  end

  def show(name)
    @user = User[:name => name]
    @user.views += 1
    @user.save
  end
end

class MainController
  include Fenestration
end

Fenestration.this_app = 'com.exampler.counting'
Ramaze.start
