#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Copyright (C) 2007, 2008 Christian Neukirchen <purl.org/net/chneukirchen>
#
# Rack is freely distributable under the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

$: << File.expand_path(File.dirname(__FILE__))


# The Rack main module, serving as a namespace for all core Rack
# modules and classes.
#
# All modules meant for use in your application are <tt>autoload</tt>ed here,
# so it should be enough just to <tt>require rack.rb</tt> in your code.

module Rack
  # The Rack protocol version number implemented.
  VERSION = [0,1]

  # Return the Rack protocol version as a dotted string.
  def self.version
    VERSION.join(".")
  end

  autoload :Builder, "rack/builder"
  autoload :Cascade, "rack/cascade"
  autoload :CommonLogger, "rack/commonlogger"
  autoload :File, "rack/file"
  autoload :ForwardRequest, "rack/recursive"
  autoload :Lint, "rack/lint"
  autoload :Recursive, "rack/recursive"
  autoload :Reloader, "rack/reloader"
  autoload :ShowExceptions, "rack/showexceptions"
  autoload :ShowStatus, "rack/showstatus"
  autoload :Static, "rack/static"
  autoload :URLMap, "rack/urlmap"
  autoload :Utils, "rack/utils"

  autoload :MockRequest, "rack/mock"
  autoload :MockResponse, "rack/mock"

  autoload :Request, "rack/request"
  autoload :Response, "rack/response"

  module Auth
    autoload :Basic, "rack/auth/basic"
    autoload :AbstractRequest, "rack/auth/abstract/request"
    autoload :AbstractHandler, "rack/auth/abstract/handler"
    autoload :OpenID, "rack/auth/openid"
    module Digest
      autoload :MD5, "rack/auth/digest/md5"
      autoload :Nonce, "rack/auth/digest/nonce"
      autoload :Params, "rack/auth/digest/params"
      autoload :Request, "rack/auth/digest/request"
    end
  end

  module Session
    autoload :Cookie, "rack/session/cookie"
    autoload :Pool, "rack/session/pool"
    autoload :Memcache, "rack/session/memcache"
  end

  # *Adapters* connect Rack with third party web frameworks.
  #
  # Rack includes an adapter for Camping, see README for other
  # frameworks supporting Rack in their code bases.
  #
  # Refer to the submodules for framework-specific calling details.

  module Adapter
    autoload :Camping, "rack/adapter/camping"
  end

  # *Handlers* connect web servers with Rack.
  #
  # Rack includes Handlers for Mongrel, WEBrick, FastCGI, CGI, SCGI
  # and LiteSpeed.
  #
  # Handlers usually are activated by calling <tt>MyHandler.run(myapp)</tt>.
  # A second optional hash can be passed to include server-specific
  # configuration.

  module Handler
    autoload :CGI, "rack/handler/cgi"
    autoload :FastCGI, "rack/handler/fastcgi"
    autoload :Mongrel, "rack/handler/mongrel"
    autoload :WEBrick, "rack/handler/webrick"
    autoload :LSWS, "rack/handler/lsws"
    autoload :SCGI, "rack/handler/scgi"
  end
end

