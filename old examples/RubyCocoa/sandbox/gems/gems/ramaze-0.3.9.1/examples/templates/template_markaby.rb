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
  template_root __DIR__/'template'
  engine :Markaby

  helper :markaby

  def index
    %{ #{A 'Home', :href => :/} | #{A(:internal)} | #{A(:external)} }
  end

  def internal *args
    options = {:place => :internal, :action => 'internal',
      :args => args, :request => request, :this => self}
    mab options do
      html do
        head do
          title "Template::Markaby #@place"
        end
        body do
          h1 "The #@place Template for Markaby"
          a("Home", :href => R(@this))
          p do
            text "Here you can pass some stuff if you like, parameters are just passed like this:"
            br
            a("#@place/one", :href => R(@this, @place, :one))
            br
            a("#@place/one/two/three", :href => R(@this, @place, :one, :two, :three))
            br
            a("#@place/one?foo=bar", :href => R(@this, @place, :one, :foo => :bar))
            br
          end
          div do
            text "The arguments you have passed to this action are:" 
            if @args.empty?
              text "none"
            else
              args.each do |arg|
                span arg
              end
            end
          end
          div @request.params.inspect
        end
      end
    end.to_s
  end

  def external *args
    @args = args
    @request = request
    @place = :external
  end
end

Ramaze.start
