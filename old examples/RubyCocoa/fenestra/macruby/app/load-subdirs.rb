#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

Dir.chdir(File.dirname(__FILE__)) do
  Dir['util/*.rb'].each { | file | require file }
  Dir['preferences/*.rb'].each { | file | require file }
  Dir['translators/*.rb'].each { | file | require file }
  Dir['main-window/*.rb'].each { | file | require file }
  Dir['prefs-window/*.rb'].each { | file | require file }
end

