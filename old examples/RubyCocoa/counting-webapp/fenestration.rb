#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'ramaze'
require 'osx/cocoa'

module Fenestration
  include Ramaze::Helper::Methods
  helper :aspect

  Center = OSX::NSDistributedNotificationCenter.defaultCenter

  def self.this_app=(what)
    const_set('THIS_APP', what)
  end

  before_all { post_note('all.before', :action => action.path.to_s) }

  before(:show) {
    post_user('show.before', action.params[0])
  }
  after(:show) {
    post_user('show.after', action.params[0])
  }

  after(:index) {
    users = DB[:users].all
    post_note('index.after', :users => users)
  }

  after(:create) {
    post_note('create.after', :name => @user.name,
                              :creations => @user.creations,
                              :flash => flash[:notice] || '')
  }

  def action
    Ramaze::Action.current
  end

  def post_note(event_tag, keys)
    puts "Posting keys " + keys.inspect
    Center.postNotificationName_object_userInfo(THIS_APP+"." + event_tag,
                                                THIS_APP,
                                                keys)
  end

  def post_user(event_tag, name)
    user = DB[:users][:name => name]
    post_note(event_tag, :user => user)
  end
end
