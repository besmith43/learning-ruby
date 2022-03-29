require 'sinatra'
require './sinatra_ssl'

set :ssl_certificate, "cert.crt"
set :ssl_key, "pkey.pem"
set :port, 9494

get '/try' do
	    "helloworld"
end
