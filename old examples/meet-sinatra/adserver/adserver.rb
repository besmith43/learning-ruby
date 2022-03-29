Dir['vendor/isolate*/lib'].each do |dir|
  $: << dir
end
require 'rubygems'
require 'isolate/now'
require 'isolate/heroku'

require 'sinatra'
require 'sqlite3'
require 'pg'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require './lib/authorization'

configure do
  # Use Heroku or local Sqlite
  DataMapper.setup(:default,
                   ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/adserver.db")
end

class Ad

  include DataMapper::Resource

  property :id,           Serial
  property :title,        String
  property :content,      Text
  property :width,        Integer
  property :height,       Integer
  property :filename,     String
  property :url,          String
  property :is_active,    Boolean
  property :created_at,   DateTime
  property :updated_at,   DateTime
  property :size,         Integer
  property :content_type, String

  has n, :clicks

  def handle_upload( file )
    self.content_type = file[:type]
    self.size = File.size(file[:tempfile])
    path = File.join(Dir.pwd, "/public/ads", self.filename)
    File.open(path, "wb") do |f|
      f.write(file[:tempfile].read)
    end
  end

end

class Click

  include DataMapper::Resource

  property :id,           Serial
  property :ip_address,   String
  property :created_at,   DateTime

  belongs_to :ad

end

configure :development do
  # Create or upgrade all tables at once, like magic
  DataMapper.auto_upgrade!
end

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

helpers do
  include Sinatra::Authorization
end

get '/' do
  erb :index
end

get '/ad' do
  id = repository(:default).adapter.query(
                                          'SELECT id FROM ads ORDER BY random() LIMIT 1;'
                                          )
  @ad = Ad.get(id)
  erb :ad
end

get '/click/:id' do
  ad = Ad.get(params[:id])
  ad.clicks.create(:ip_address => env["REMOTE_ADDR"])
  redirect(ad.url)
end

get '/show/:id' do
  @ad = Ad.get(params[:id])
  if @ad
    erb :show
  else
    redirect('/list')
  end
end

get '/new' do
  require_admin
  @page_title = "New Ad"
  erb :new
end

post '/create' do
  require_admin
  @ad = Ad.new(params[:ad])
  @ad.handle_upload(params[:image])
  if @ad.save
    redirect "/show/#{@ad.id}"
  else
    redirect('/list')
  end
end

get '/delete/:id' do
  require_admin
  ad = Ad.get(params[:id])
  path = File.join(Dir.pwd, "/public/ads", ad.filename)
  File.delete(path)
  ad.delete unless ad.nil?
  redirect('/list')
end

get '/list' do
  require_admin
  @page_title = "List Ads"
  @ads = Ad.all(:order => [:created_at.desc])
  erb :list
end
