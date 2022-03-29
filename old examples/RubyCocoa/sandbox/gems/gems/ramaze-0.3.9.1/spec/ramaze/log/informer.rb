#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

describe 'Informer' do
  before do
    @out = []
    def @out.puts(*args) push(*args) end
    Ramaze::Informer.trait[:colorize] = false
    @inform = Ramaze::Informer.new(@out)
  end

  def format(tag, string)
    /\[\d{4}-\d\d-\d\d \d\d:\d\d:\d\d\] #{tag.to_s.upcase.ljust(5)}  #{Regexp.escape(string)}/
  end

  it 'info' do
    @inform.info('Some Info')
    @out.first.should =~ format(:info, 'Some Info')
  end

  it 'debug' do
    arr = [:some, :stuff]
    @inform.debug(arr)
    @out.first.should =~ format(:debug, arr.inspect)
  end

  it 'warn' do
    @inform.warn('More things')
    @out.first.should =~ format(:warn, 'More things')
  end

  it 'error' do
    begin
      raise('Stuff')
    rescue => ex
    end

    @inform.error(ex)
    @out.first.should =~ format(:error, ex.inspect)
  end

  it 'should choose stdout on init(stdout,:stdout,STDOUT)' do
    a = Ramaze::Informer.new(STDOUT)
    b = Ramaze::Informer.new(:stdout)
    c = Ramaze::Informer.new('stdout')
    [a,b,c].each { |x| x.out.should == $stdout}
  end

  it 'should choose stderr on init(stderr,:stderr,STDERR)' do
    a = Ramaze::Informer.new(STDERR)
    b = Ramaze::Informer.new(:stderr)
    c = Ramaze::Informer.new('stderr')
    [a,b,c].each { |x| x.out.should == $stderr}
  end

  it 'should use IO when supplied' do
    i = Ramaze::Informer.new(s = StringIO.new)
    i.out.should == s
  end

  it 'should open file otherwise' do
    begin
      i = Ramaze::Informer.new('tmp.dummy')
      out = i.out
      out.should.be.instance_of(File)
      out.path.should == 'tmp.dummy'
    ensure
      out.close
      File.delete('tmp.dummy')
    end
  end

end
