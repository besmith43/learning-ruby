#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'rake/contrib/sshpublisher'

module Rake

  class RubyForgePublisher < SshDirPublisher
    attr_reader :project, :proj_id, :user
    
    def initialize(projname, user)
      super(
        "#{user}@rubyforge.org",
        "/var/www/gforge-projects/#{projname}",
        "html")
    end
  end
  
end
