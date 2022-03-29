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
require 'ramaze/gestalt'

class MainController < Ramaze::Controller
  template_root __DIR__/:template
  engine :XSLT

  def index
    redirect R(:external)
  end

  def external *args
    r = lambda { |*a| R(*a) }
    response['Content-Type'] = 'application/xhtml+xml'

    #options = {:place => :internal, :action => 'internal',
    #  :args => args, :request => request, :this => self}
    Ramaze::Gestalt.build do
      page(:title=>"Template::XSLT") do
        heading "The external Template for XSLT"
        text "Here you can pass some stuff if you like, parameters are just passed like this:"
        list do
          item {
            link(:href => r.call(@this, :external, :one)) { "external/one" }
          }
          item {
            link(:href => r.call(@this, :external, :one, :two, :three)) { "external/one/two/three" }
          }
          item {
            link(:href => r.call(@this, :external, :one, :foo => :bar)) { "external/one?foo=bar" }
          }
        end
        text "The arguments you have passed to this action are:"
        if args.empty?
          text "none"
        else
          list {
            args.each do |arg|
              item arg
            end
          }
        end
      end
    end
  end
end

Ramaze.start
