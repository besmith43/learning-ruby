#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'ramaze'

class MainController < Ramaze::Controller
  template_root __DIR__/:template
  engine :Haml

  def index
    %{ #{A 'Home', :href => :/} | #{A(:internal)} | #{A(:external)} }
  end

  def internal *args
    @args = args
    @place = :internal
    @title = "The #@place Template for Haml"

    %q{
%html
  %head
    %title= "Template::Haml #@place"
  %body
    %h1= @title
    = A('Home', :href => :/)
    %p
      Here you can pass some stuff if you like, parameters are just passed like this:
      %br/
      = A("#@place/one")
      %br/
      = A("#@place/one/two/three")
      %br/
      = A("#@place/one?foo=bar")
    %div 
      The arguments you have passed to this action are:
      - if @args.empty?
        none
      - else
        - @args.each do |arg|
          %span= arg
    %div= request.params.inspect
    }
  end

  def external *args
    @args = args
    @place = :external
    @title = "The #@place Template for Haml"
  end
end

Ramaze.start
