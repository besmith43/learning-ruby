#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

class TCActionCache < Ramaze::Controller
  map '/'
  helper :cache

  def index
    rand
  end
  cache :index
end

class TCOtherCache < Ramaze::Controller
  map '/other'
  helper :cache

  def index
    rand
  end
  cache :index
end

describe 'Action rendering' do
  behaves_like 'http'

  @public_root = __DIR__ / :public
  FileUtils.mkdir_p @public_root
  ramaze :file_cache => true

  def req(path) r = get(path); [r.content_type, r.body] end

  it 'should cache to file' do
    lambda{ req('/') }.should.not.change{ req('/') }
    File.file?(@public_root/'index').should == true
  end

  it 'should create subdirs as needed' do
    lambda{ req('/other') }.should.not.change{ req('/other') }
    File.file?(@public_root/'other'/'index').should == true
  end

  FileUtils.rm_rf @public_root
end
