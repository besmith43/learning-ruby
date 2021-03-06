#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Rack
  # Rack::URLMap takes a hash mapping urls or paths to apps, and
  # dispatches accordingly.  Support for HTTP/1.1 host names exists if
  # the URLs start with <tt>http://</tt> or <tt>https://</tt>.
  #
  # URLMap modifies the SCRIPT_NAME and PATH_INFO such that the part
  # relevant for dispatch is in the SCRIPT_NAME, and the rest in the
  # PATH_INFO.  This should be taken care of when you need to
  # reconstruct the URL in order to create links.
  #
  # URLMap dispatches in such a way that the longest paths are tried
  # first, since they are most specific.

  class URLMap
    def initialize(map)
      @mapping = map.map { |location, app|
        if location =~ %r{\Ahttps?://(.*?)(/.*)}
          host, location = $1, $2
        else
          host = nil
        end

        location = ""  if location == "/"

        [host, location, app]
      }.sort_by { |(h, l, a)| -l.size } # Longest path first
    end

    def call(env)
      path = env["PATH_INFO"].to_s.squeeze("/")
      hHost, sName, sPort = env.values_at('HTTP_HOST','SERVER_NAME','SERVER_PORT')
      @mapping.each { |host, location, app|
        if (hHost == host || sName == host \
          || (host.nil? && (hHost == sName || hHost == sName+':'+sPort))) \
          and location == path[0, location.size] \
          and (path[location.size] == nil || path[location.size] == ?/)
          env["SCRIPT_NAME"] += location.dup
          env["PATH_INFO"] = path[location.size..-1]
          env["PATH_INFO"].gsub!(/\/\z/, '')
          env["PATH_INFO"] = "/"  if env["PATH_INFO"].empty?
          return app.call(env)
        end
      }
      [404, {"Content-Type" => "text/plain"}, ["Not Found: #{path}"]]
    end
  end
end

