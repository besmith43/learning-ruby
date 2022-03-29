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
  engine :Remarkably

  include Remarkably::Common

  def index
    %{ #{A 'Home', :href => :/} | #{A(:internal)} | #{A(:external)} }
  end

  def internal *args
    @place = :internal
    html do
      head do
        title "Template::Remarkably internal"
      end
      body do
        h1 "The #@place Template for Remarkably"
        a("Home", :href => R(:/))
        P do
          text "Here you can pass some stuff if you like, parameters are just passed like this:"
          br
          a("#@place/one", :href => Rs( @place, :one))
          br
          a("#@place/one/two/three", :href => Rs( @place, :one, :two, :three))
          br
          a("#@place/one?foo=bar", :href => Rs( @place, :one, :foo => :bar))
          br
        end
        div do
          text "The arguments you have passed to this action are:" 
          if args.empty?
            "none"
          else
            args.each do |arg|
              span arg
            end
          end
        end
        div request.params.inspect
      end
    end
  end

  def external *args
    @args = args
    @place = :external
    @request = request
  end
end

Ramaze.start
