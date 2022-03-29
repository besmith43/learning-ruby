#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

describe 'Dispatcher::File' do
  behaves_like 'http'
  @public_root = 'spec/ramaze/dispatcher/public'
  ramaze :public_root => @public_root

  it 'should serve from Global.public_root' do
    css = File.read(@public_root/'test_download.css')
    re_css = get('/test_download.css')
    re_css.body.should == css
    re_css.status.should == 200
  end

  it 'should give priority to Global.public_root' do
    file = (@public_root/'favicon.ico')
    if RUBY_VERSION >= '1.9.0'
      original = File.open(file, 'r:ASCII'){|f| f.read}
    else
      original = File.read(file)
    end
    get('/favicon.ico').body.should == original
  end

  it 'should work on files with spaces' do
    res = get('/file%20name.txt')
    res.status.should == 200
    res.body.should == 'hi'
  end

  it 'should send ETag' do
    res = get '/test_download.css'
    res.headers['ETag'].should.not.be == nil
    res.headers['ETag'].length.should == 34  # "32 hash"
  end

  it 'should send Last-Modified' do
    res = get '/test_download.css'
    res.headers['Last-Modified'].should.not.be == nil
    res.headers['Last-Modified'].should == File.stat(@public_root/'test_download.css').mtime.httpdate
  end

  it 'should respect ETag with IF_NONE_MATCHES' do
    res = get '/test_download.css'
    etag = res.headers['ETag']
    etag.should.not.be == nil
    res = get '/test_download.css', :if_none_match=>etag
    res.status.should == 304
    res.body.should == ''
  end

  it 'should respect If-Modified' do
    res = get '/test_download.css'
    mtime = res.headers['Last-Modified']
    mtime.should.not.be == nil
    res = get '/test_download.css', :if_modified_since=>mtime
    res.status.should == 304
    res.body.should == ''
  end
end