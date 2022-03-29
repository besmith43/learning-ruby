#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

class Thread
  # Copy following:
  #   :action, :response, :request, :session,
  #   :task, :adapter, :controller, :exception

  def self.into *args
    Thread.new(Thread.current, *args) do |thread, *args|
      thread.keys.each do |k|
        Thread.current[k] = thread[k] unless k.to_s =~ /^__/
      end

      yield *args
    end
  end
end
