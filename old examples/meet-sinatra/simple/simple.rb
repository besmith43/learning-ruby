require 'rubygems'
require 'sinatra'

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Hello"
  erb :form
end

post '/' do
  @name = "#{params[:post][:first_name]} #{params[:post][:last_name]}"
  @title = "Hello #{@name}"
  erb :hello
end
