#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
puts 'Using native Frontbase'
require_dependency 'models/course'
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'arunit' => {
    :adapter => 'frontbase',
    :host => 'localhost',
    :username => 'rails',
    :password => '',
    :database => 'activerecord_unittest',
    :session_name => "unittest-#{$$}"
  },
  'arunit2' => {
    :adapter => 'frontbase',
    :host => 'localhost',
    :username => 'rails',
    :password => '',
    :database => 'activerecord_unittest2',
    :session_name => "unittest-#{$$}"
  }
}

ActiveRecord::Base.establish_connection 'arunit'
Course.establish_connection 'arunit2'
