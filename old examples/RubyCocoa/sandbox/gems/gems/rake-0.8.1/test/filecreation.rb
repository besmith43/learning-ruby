#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

module FileCreation
  OLDFILE = "testdata/old"
  NEWFILE = "testdata/new"

  def create_timed_files(oldfile, *newfiles)
    return if File.exist?(oldfile) && newfiles.all? { |newfile| File.exist?(newfile) }
    old_time = create_file(oldfile)
    newfiles.each do |newfile|
      while create_file(newfile) <= old_time
        sleep(0.1)
        File.delete(newfile) rescue nil
      end
    end
  end

  def create_dir(dirname)
    FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
    File.stat(dirname).mtime
  end

  def create_file(name)
    create_dir(File.dirname(name))
    FileUtils.touch(name) unless File.exist?(name)
    File.stat(name).mtime
  end

  def delete_file(name)
    File.delete(name) rescue nil
  end
end
