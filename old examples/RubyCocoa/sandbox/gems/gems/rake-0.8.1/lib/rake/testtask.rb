#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

# Define a task library for running unit tests.

require 'rake'
require 'rake/tasklib'

module Rake

  # Create a task that runs a set of tests.
  #
  # Example:
  #  
  #   Rake::TestTask.new do |t|
  #     t.libs << "test"
  #     t.test_files = FileList['test/test*.rb']
  #     t.verbose = true
  #   end
  #
  # If rake is invoked with a "TEST=filename" command line option,
  # then the list of test files will be overridden to include only the
  # filename specified on the command line.  This provides an easy way
  # to run just one test.
  #
  # If rake is invoked with a "TESTOPTS=options" command line option,
  # then the given options are passed to the test process after a
  # '--'.  This allows Test::Unit options to be passed to the test
  # suite.
  #
  # Examples:
  #
  #   rake test                           # run tests normally
  #   rake test TEST=just_one_file.rb     # run just one test file.
  #   rake test TESTOPTS="-v"             # run in verbose mode
  #   rake test TESTOPTS="--runner=fox"   # use the fox test runner
  #
  class TestTask < TaskLib

    # Name of test task. (default is :test)
    attr_accessor :name

    # List of directories to added to $LOAD_PATH before running the
    # tests. (default is 'lib')
    attr_accessor :libs

    # True if verbose test output desired. (default is false)
    attr_accessor :verbose

    # Test options passed to the test suite.  An explicit
    # TESTOPTS=opts on the command line will override this. (default
    # is NONE)
    attr_accessor :options

    # Request that the tests be run with the warning flag set.
    # E.g. warning=true implies "ruby -w" used to run the tests.
    attr_accessor :warning

    # Glob pattern to match test files. (default is 'test/test*.rb')
    attr_accessor :pattern

    # Style of test loader to use.  Options are:
    #
    # * :rake -- Rake provided test loading script (default).
    # * :testrb -- Ruby provided test loading script.
    # * :direct -- Load tests using command line loader.
    # 
    attr_accessor :loader

    # Array of commandline options to pass to ruby when running test loader.
    attr_accessor :ruby_opts

    # Explicitly define the list of test files to be included in a
    # test.  +list+ is expected to be an array of file names (a
    # FileList is acceptable).  If both +pattern+ and +test_files+ are
    # used, then the list of test files is the union of the two.
    def test_files=(list)
      @test_files = list
    end

    # Create a testing task.
    def initialize(name=:test)
      @name = name
      @libs = ["lib"]
      @pattern = nil
      @options = nil
      @test_files = nil
      @verbose = false
      @warning = false
      @loader = :rake
      @ruby_opts = []
      yield self if block_given?
      @pattern = 'test/test*.rb' if @pattern.nil? && @test_files.nil?
      define
    end

    # Create the tasks defined by this task lib.
    def define
      lib_path = @libs.join(File::PATH_SEPARATOR)
      desc "Run tests" + (@name==:test ? "" : " for #{@name}")
      task @name do
        run_code = ''
        RakeFileUtils.verbose(@verbose) do
          run_code =
            case @loader
            when :direct
              "-e 'ARGV.each{|f| load f}'"
            when :testrb
              "-S testrb #{fix}"
            when :rake
              rake_loader
            end
          @ruby_opts.unshift( "-I#{lib_path}" )
          @ruby_opts.unshift( "-w" ) if @warning
          ruby @ruby_opts.join(" ") +
            " \"#{run_code}\" " +
            file_list.collect { |fn| "\"#{fn}\"" }.join(' ') +
            " #{option_list}"
        end
      end
      self
    end

    def option_list # :nodoc:
      ENV['TESTOPTS'] || @options || ""
    end

    def file_list # :nodoc:
      if ENV['TEST']
        FileList[ ENV['TEST'] ]
      else
        result = []
        result += @test_files.to_a if @test_files
        result += FileList[ @pattern ].to_a if @pattern
        FileList[result]
      end
    end

    def fix # :nodoc:
      case RUBY_VERSION
      when '1.8.2'
        find_file 'rake/ruby182_test_unit_fix'
      else
        nil
      end || ''
    end

    def rake_loader # :nodoc:
      find_file('rake/rake_test_loader') or
        fail "unable to find rake test loader"
    end

    def find_file(fn) # :nodoc:
      $LOAD_PATH.each do |path|
        file_path = File.join(path, "#{fn}.rb")
        return file_path if File.exist? file_path
      end
      nil
    end

  end
end
