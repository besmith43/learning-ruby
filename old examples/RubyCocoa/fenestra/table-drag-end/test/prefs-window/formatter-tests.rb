#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")
require File.dirname(__FILE__) + "/testutil"

module PrefsWindowTests
  class BasenameFormatterTests < Test::Unit::TestCase
    include OSX

    def setup
      @formatter = BasenameFormatter.alloc.init
    end

    context "formatting on the way to text field" do 

      should "convert nil to empty string" do
        assert { @formatter.stringForObjectValue(nil) == '' }
        assert { @formatter.editingStringForObjectValue(nil) == "" }
      end


      should "convert whole pathname to basename" do
        assert { @formatter.stringForObjectValue("/path/to/file.rb") ==
                 "file.rb" }
      end


      should "leave pathname intact if value is for editing" do
        name = "/path/to/file.rb"
        assert { @formatter.editingStringForObjectValue(name) == name }
      end

      should "leave the empty string alone" do
        assert { @formatter.stringForObjectValue("") == "" }
      end

    end

    context "validation of edits in text field" do
      should "reject a string not ending in '.rb'" do

        ['rb', 'not even close'].each do | name |
          accepted, obj, message =
              @formatter.objc_send('getObjectValue:forString', name,
                                   'errorDescription')
          deny { accepted }
          assert { obj.nil? }
          assert { message.to_ruby =~ /'#{name}'/ }
          assert { message.to_ruby =~ /must end in '.rb'/ }
        end
      end


      should "reject a file that doesn't exist" do
        name = "/does/not/exist.rb"
        accepted, obj, message =
            @formatter.objc_send('getObjectValue:forString', name,  
                                 'errorDescription')
        deny { accepted }
        assert { obj.nil? }
        assert { message.to_ruby  =~ /'#{name}'/ } # (1)
        assert { message.to_ruby  =~ /must exist/ } # (2) 

      end


      should "accept a ruby file" do
        name = File.join(RubyCocoaLocations.root_for_ruby_files,
                         'path-setting.rb')
        accepted, obj, message =
            @formatter.objc_send('getObjectValue:forString', name,
                                 'errorDescription')
        assert { accepted }
        assert { obj == name }
        assert { message == nil }
      end


      should "not return an error message unless one is asked for" do
        name = "invalid"
        accepted, obj = @formatter.objc_send('getObjectValue:forString', name,
                                             'errorDescription', nil)
        deny { accepted }
        assert { obj.nil? }
      end

    end


    context "utilities" do

      should "expand tildes when checking file existence" do
        @formatter.extend(Fenestrable)  # (3)

        assert { @formatter.fenestra.file_exists?("~".to_ns) } # (4)

      end


      # I didn't write a test that tilde-abbreviation is actually used
      # because that's awkward. (That's a sign that I'm doing work in
      # the wrong place.)
    end
  end
end
