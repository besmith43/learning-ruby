#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

class Page < Ezamar::Element
  def render
    %{
    <html>
      <head>
        <title>TodoList</title>
        <style>
          table     { width:       100%;              }
          tr        { background:  #efe; width: 100%; }
          tr:hover  { background:  #dfd;              }
          td.title  { font-weight: bold; width: 60%;  }
          td.status { margin:      1em;               }
          a         { color:       #3a3;              }
        </style>
      </head>
      <body>
        <h1>#{@title}</h1>
        <?r if flash[:error] ?>
          <div class="error">
            \#{flash[:error]}
          </div>
        <?r end ?>
        #{content}
      </body>
    </html>
    }
  end
end
