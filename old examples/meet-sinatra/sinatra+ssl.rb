#!/usr/bin/env ruby
#
# This code snippet shows how to enable SSL in Sinatra.
#

require 'sinatra/base'

class Application < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :port, 443
  end

  get '/' do
    'Hello, SSL.'
  end

  def self.run!
    super do |server|
      server.ssl = true
      server.ssl_options = {
        :cert_chain_file  => File.dirname(__FILE__) + "/server.crt",
        :private_key_file => File.dirname(__FILE__) + "/server.key",
        :verify_peer      => false
      }
    end
  end

  run! if app_file == $0
end