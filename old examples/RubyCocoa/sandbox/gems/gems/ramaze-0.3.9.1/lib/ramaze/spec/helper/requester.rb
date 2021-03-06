#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

module Requester
  def get url = '/', hash = {}
    request(:get, url, hash)
  end

  def post url = '/', hash = {}
    request(:post, url, hash)
  end

  def request method, url, hash = {}
    http = SimpleHttp.new(url2uri(url))
    if method == :get and not hash.empty?
      http.uri.query = hash.map{|k,v| "#{k}=#{v}"}.join('&')
      hash = {}
    end

    puts "#{method.to_s.upcase} => #{http.uri}"
    http.send(method, hash).strip
  end

  def epost url = '/', hash = {}
    erequest(:post, url, hash)
  end

  def eget url = '/', hash = {}
    erequest(:get, url, hash)
  end

  def erequest method, url, hash = {}
    response = request(method, url, hash)
    eval(response)
  rescue Object => ex
    p :response => response
    ex.message
  end

  def url2uri url
    uri = URI.parse(url)
    #p uri.methods.sort.grep(/=/)
    uri.scheme = 'http'
    uri.host = 'localhost'
    uri.port = Ramaze::Global.port
    uri.path = "/#{url}".squeeze('/')
    uri
  end
end
