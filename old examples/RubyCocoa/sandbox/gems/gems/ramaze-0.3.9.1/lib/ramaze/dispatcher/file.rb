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

require "time"
require 'digest/md5'

module Ramaze
  module Dispatcher

    # First of the dispatchers, looks up the public path and serves the
    # file if found.

    class File
      # These names are checked for serving from public directory.
      # They take priority over Actions which comes later in the FILTER
      INDICES = %w[index.htm index.xhtml index.html index]

      class << self
        include Trinity

        # Entry point from Dispatcher::filter.
        # searches for the file and builds a response with status 200 if found.

        def process(path)
          return unless file = open_file(CGI.unescape(path))
          if file == :NotModified
            return response.build([], STATUS_CODE['Not Modified'])
          end
          response.build(file, STATUS_CODE['OK'])
        end

        # returns file-handle with the open file on success, setting the
        # Content-Type as found in Tool::MIME

        def open_file(path)
          file = resolve_path(path)

          if ::File.file?(file) or ::File.file?(file=file/'index')
            return unless in_public?(file)
            response['Content-Type'] = Tool::MIME.type_for(file) unless ::File.extname(file).empty?
            mtime = ::File.mtime(file)
            response['Last-Modified'] = mtime.httpdate
            response['ETag']= Digest::MD5.hexdigest(file+mtime.to_s).inspect
            if modified_since = request.env['HTTP_IF_MODIFIED_SINCE']
              return :NotModified unless Time.parse(modified_since) < mtime
            elsif match = request.env['HTTP_IF_NONE_MATCH']
              # Should be a unique string enclosed in ""
              # To avoiding more file reading we use mtime and filepath
              # we could throw in inode and size for more uniqueness
              return :NotModified if response['ETag']==match
            end
            log(file)
            ::File.open(file, 'rb')
          end
        end

        def resolve_path(path)
          joined = ::File.join(Global.public_root, path)

          if ::File.directory?(joined)
            Dir[joined/"{#{INDICES.join(',')}}"].first || joined
          else
            joined
          end
        end

        def in_public?(path)
          expand(path).start_with?(expand(Global.public_root))
        end

        private

        def expand(path)
          ::File.expand_path(path)
        end

        def log(file)
          case file
          when *Global.boring
          else
            Log.debug("Serving static: #{file}")
          end
        end
      end
    end
  end
end
