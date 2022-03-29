require 'sinatra'

get '/' do
    "hello world"
end

get '/:name' do
    "hi #{params['name']}"
end
