#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# This file loads subdirectories in a particular order, which cuts down
# on the number of times you need to put explicit 'require' statements
# in other files.

Dir.chdir(File.dirname(__FILE__)) do
  Dir['util/*.rb'].each { | file | require file }
  Dir['translators/*.rb'].each { | file | require file }
  Dir['controllers/*.rb'].each { | file | require file }
end

