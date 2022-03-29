#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'

=begin

This file is to be copied into your app's top-level directory (where
rb_main.rb is). It should be included in rb_main.rb. After that, calls
to module methods defined here will set paths and load Ruby files.

If you'll be putting all your Ruby files under an app/ directory, use
the following to load them. This also makes sure that the only
external libraries used are those that come with the OS (app isolation).

Note that load_ruby_files() only loads the Ruby files from the top
level of app. It doesn't do a recursive load of all files in the tree.

require 'path-setting'

if $0 == __FILE__ then
  OSX::NSLog "RubyCocoa version is #{OSX::RUBYCOCOA_VERSION}."
  OSX::NSLog "Using Ruby files in #{RubyCocoaLocations::app_root}."
  RubyCocoaLocations.set_hierarchical_app_load_paths
  RubyCocoaLocations.load_ruby_files
  OSX.NSApplicationMain(0, nil)
end

If you only want app isolation, do the following. Note that
rb_main_init is the method that comes with RubyCocoa.

if $0 == __FILE__ then
  OSX::NSLog "RubyCocoa version is #{OSX::RUBYCOCOA_VERSION}."
  RubyCocoaLocations.restrict_load_path_to_OSX_defaults
  RubyCocoaLocations.make_chosen_libs_and_gems_available
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end

=end

module RubyCocoaLocations

  def self.set_hierarchical_app_load_paths
    remove_normal_rubycoca_app_paths
    restrict_load_path_to_OSX_defaults
    make_chosen_libs_and_gems_available
    make_app_ruby_files_available
  end

  def self.remove_normal_rubycoca_app_paths
    $:.delete(RubyCocoaLocations.resource_path)
    $:.delete('.')
  end

  def self.restrict_load_path_to_OSX_defaults
    require 'rbconfig'
    $:.delete_if { | p | p =~ Regexp.new(RbConfig::CONFIG['sitedir']) }
    ENV['RUBYLIB'].split(':').each do | path |
      $:.delete(path)
    end if ENV.has_key?('RUBYLIB')
  end

  def self.make_chosen_libs_and_gems_available
    $: << root_for_ruby_files + "/third-party/lib"
    RbConfig::CONFIG['sitelibdir'] = $:.last   # Rubygems uses this
    unless require 'rubygems'
      Gem::ConfigMap[:sitelibdir] = $:.last
    end
    Gem.clear_paths
    ENV['GEM_HOME'] = root_for_ruby_files + "/third-party/gems"
  end

  def self.make_app_ruby_files_available
    $:.unshift(app_root)
  end

  def self.load_ruby_files
    require 'load-subdirs.rb'   # Order is important.
    rbfiles = Dir.chdir(app_root) { Dir["*.rb"] }
    rbfiles.each { |file| require(file) }
  end

  def self.root_for_ruby_files
    if debug_build?
      File.expand_path(resource_path + "/../../../../..")
    else
      resource_path
    end
  end

  def self.app_root
    root_for_ruby_files + "/app"
  end

  def self.debug_build?
    resource_path =~ %r{/build/Debug/\w+.app/}
  end

  def self.resource_path
    OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  end

  def self.dir_in_which(start=Dir.getwd, &block)
    return File.expand_path(start) if block.call(start)
    dir_in_which(File.join(start, '..'), &block)
  end

  def self.dir_containing(file_basename)
    dir_in_which { | dirname | 
      File.exist?(File.join(dirname, file_basename)) 
    }
  end
end
