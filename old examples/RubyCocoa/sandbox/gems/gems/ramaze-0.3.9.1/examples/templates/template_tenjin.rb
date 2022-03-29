#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require "rubygems"
require "ramaze"

class MainController < Ramaze::Controller
  template_root __DIR__/:template
  engine :Tenjin

  def index
    %{ #{A 'Home', :href => :/} | #{A(:internal)} | #{A(:external)} }
  end

  def internal(*args)
    @context = {
      :args => args,
      :place => :internal
    }
    <<'__TENJIN__'
<html>
  <head>
    <title>Template::Tenjin #{@place}</title>
  </head>
  <body>
  <h1>The #{@place} Template for Tenjin</h1>
  <a href="#{Rs(:/)}">Home</a>
  <p>
  Here you can pass some stuff if you like, parameters are just passed like this:<br />
  <a href="#{Rs(@place, :one)}">#{Rs(@place, :one)}</a><br />
  <a href="#{Rs(@place, :two, :three)}">#{Rs(@place, :two, :three)}</a><br />
  <a href="#{Rs(@place, :one, :foo => :bar)}">#{Rs(@place, :one, :foo => :bar)}</a>
  </p>

  <div>
    The arguments you have passed to this action are:<br />
    <?rb if @args.empty? ?>
      none
    <?rb else ?>
      <?rb @args.each do |arg| ?>
        <span>#{arg}</span>
      <?rb end ?>
    <?rb end ?>
  </div>

  <div>#{request.params.inspect}</div>
  </body>
</html>
__TENJIN__
  end

  def external(*args)
    @context = {
      :args => args,
      :place => :external
    }
  end
end

Ramaze.start
