#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'sinatra/base'

module Faraday
class LiveServer < Sinatra::Base
  set :environment, :test
  disable :logging
  disable :protection

  [:get, :post, :put, :patch, :delete, :options].each do |method|
    send(method, '/echo') do
      kind = request.request_method.downcase
      out = kind.dup
      out << ' ?' << request.GET.inspect if request.GET.any?
      out << ' ' << request.POST.inspect if request.POST.any?

      content_type 'text/plain'
      return out
    end
  end

  get '/echo_header' do
    header = "HTTP_#{params[:name].tr('-', '_').upcase}"
    request.env.fetch(header) { 'NONE' }
  end

  post '/file' do
    if params[:uploaded_file].respond_to? :each_key
      "file %s %s %d" % [
        params[:uploaded_file][:filename],
        params[:uploaded_file][:type],
        params[:uploaded_file][:tempfile].size
      ]
    else
      status 400
    end
  end

  get '/multi' do
    [200, { 'Set-Cookie' => 'one, two' }, '']
  end

  get '/slow' do
    sleep 10
    [200, {}, 'ok']
  end

  get '/ssl' do
    request.secure?.to_s
  end

  error do |e|
    "#{e.class}\n#{e.to_s}\n#{e.backtrace.join("\n")}"
  end
end
end

if $0 == __FILE__
  Faraday::LiveServer.run!
end
