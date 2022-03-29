#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Translator'
require 'Linguistics'
Linguistics.use 'en'

module Translators
  class CountingApp < Translator
    def self.when_hearing_about(suffix, &block)
      object = "com.exampler.counting"
      name = "#{object}.#{suffix}"
      on_remote_notification(name, object, &block)
    end

    when_hearing_about("all.before") do | notification | 
      translate_as "= action: #{notification[:action]}"
    end
    
    when_hearing_about('show.before') do | notification |
      translate_user(notification[:user], :prefix => "before action:\t")
    end

    when_hearing_about('show.after') do | notification |
      translate_user(notification[:user], :prefix => "after action:\t")
    end

    when_hearing_about('create.after') do | notification |
      name = notification['name']
      if notification['creations'].to_ruby == 1
        translate_as %Q{User "#{name}" was successfully created.}
      else
        translate_as %Q{User "#{name}" already existed.}
        translate_as %Q{Flash: "#{notification['flash']}"}
      end
    end

    when_hearing_about('index.after') do | notification |
      users = notification[:users]
      translate_as "Number of users: #{users.size}"
      users.each do | user |
        translate_user(user)
      end
    end

    module Privates
      def translate_user(user, options = {})
        name, creations, views = user['name'], user['creations'],  user['views']
        prefix = options[:prefix]
        translate_as %Q{  #{prefix}"#{name}" has been created #{times(creations)} and viewed #{times(views)}.}
      end
    
      def numword(count)
        count = count.to_ruby  # (1)
        if count < 20
          count.en.numwords
        else
          count.to_s
        end
      end
    
      def times(count)
        "#{numword(count)} #{'time'.en.plural(count)}"
      end
    end
    include Privates
  end
end
