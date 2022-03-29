WARBLER_CONFIG = {}
ENV['GEM_HOME'] = File.expand_path(File.join('..', '..', '/'), __FILE__)
ENV['GEM_PATH'] = nil # RGs sets Gem.paths.path = Gem.default_path + [ GEM_HOME ]
require 'rubygems' unless defined?(Gem)
$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'cli_warble/lib'), __FILE__)
