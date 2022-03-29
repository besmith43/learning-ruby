#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

module Ramaze
  module Tool

    # Responsible for lookup of MIME info for filetypes based on extension.

    module MIME

      # the mime_types.yaml as full path, we use a copy of mongrels.
      trait :types => YAML.load_file(BASEDIR/'ramaze'/'tool'/'mime_types.yaml')

      class << self

        # Get MIME-type for the given filename based on extension.
        # Answers with an empty string if none is found.
        def type_for file
          ext = File.extname(file)
          trait[:types][ext].to_s
        end
      end
    end
  end
end
