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

require 'ramaze'
require 'rack/mock'

module Ramaze
  module Adapter
    class Fake < Base
    end
  end
end

module MockHTTP
  DEFAULTS = {
    'REMOTE_ADDR' => '127.0.0.1'
  }

  MOCK_URI = URI::HTTP.build(
    :host => 'localhost',
    :port => 80
  )

  FISHING = {
    :input => :input,
    :referrer => 'HTTP_REFERER',
    :referer => 'HTTP_REFERER',
    :cookie => 'HTTP_COOKIE',
    :if_none_match=> 'HTTP_IF_NONE_MATCH',
    :if_modified_since=> 'HTTP_IF_MODIFIED_SINCE',
  }

  MOCK_REQUEST = ::Rack::MockRequest.new(Ramaze::Adapter::Fake)

  def get(*args)    mock_request(:get,    *args) end
  def put(*args)    mock_request(:put,    *args) end
  def post(*args)   mock_request(:post,   *args) end
  def delete(*args) mock_request(:delete, *args) end

  def mock_request(meth, path, query = {})
    uri, options = process_request(path, query)
    MOCK_REQUEST.send(meth, uri, DEFAULTS.merge(options))
  end

  def raw_mock_request(meth, uri, options = {})
    MOCK_REQUEST.send(meth, uri, DEFAULTS.merge(options))
  end

  def process_request(path, query)
    options = {}
    FISHING.each{|key, value|
      options[value] = query.delete(key)} if query.is_a?(Hash)
    [create_url(path, query), options]
  end

  def create_url(path, query)
    uri = MOCK_URI.dup
    uri.path = path
    uri.query = make_query(query)
    uri.to_s
  end

	def make_query query
		return query unless query and not query.is_a?(String)
    query.map{|key, value|
      "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
    }.join('&')
	end
end
