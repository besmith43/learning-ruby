#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rbconfig'
require 'find'
require 'ftools'

include Config

def indir(newdir)
  olddir = Dir.pwd
  Dir.chdir(newdir)
  yield
ensure
  Dir.chdir(olddir)
end

$ruby = CONFIG['ruby_install_name']
$sitedir = CONFIG["sitelibdir"]

unless $sitedir
  version = CONFIG["MAJOR"]+"."+CONFIG["MINOR"]
  $libdir = File.join(CONFIG["libdir"], "ruby", version)
  $sitedir = $:.find {|x| x =~ /site_ruby/}
  if !$sitedir
    $sitedir = File.join($libdir, "site_ruby")
  elsif $sitedir !~ Regexp.quote(version)
    $sitedir = File.join($sitedir, version)
  end
end

if (destdir = ENV['DESTDIR'])
  $sitedir = destdir + $sitedir
  File::makedirs($sitedir)
end

flexmock_dest = File.join($sitedir, "flexmock")
File::makedirs(flexmock_dest, true)
File::chmod(0755, flexmock_dest)
# The library files

file = 'flexmock.rb'

indir('lib') do
  Dir['**/*.rb'].each do |file|
    File::install(
      file,
      File.join($sitedir, file),
      0644,
      true)
  end
end


