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

  # Helper::Redirect actually takes advantage of Helper::Link.link_raw to build the links
  # it redirects to.
  # It doesn't do much else than this:
  #     setting a status-code of 303 and a response['Location'] = link
  # returning some nice text for visitors who insist on ignoring those hints :P
  #
  # Usage:
  #   redirect Rs()
  #   redirect R(MainController)
  #   redirect R(MainController, :foo)
  #   redirect 'foo/bar'
  #   redirect 'foo/bar', :status => 301
  #
  # TODO:
  #   - maybe some more options, like a delay
  #

  module Helper::Redirect

    # render to the browser directly, ignoring any templates
    def respond *args
      response.build(*args)
      throw :respond
    end

    # Usage:
    #   redirect Rs()
    #   redirect R(MainController)
    #   redirect R(MainController, :foo)
    #   redirect 'foo/bar'
    #   redirect 'foo/bar', :status => 301

    def redirect target, opts = {}
      target = target.to_s

      unless target =~ %r!^https?://!
        target[0,0] = '/' unless target =~ %r!^/!
        if host = request.env['HTTP_HOST']
          target[0,0] = "http://#{host}"
        end
      end

      raw_redirect(target, opts)
    end

    def raw_redirect(target, opts = {})
      target = target.to_s
      header = {'Location' => target}
      status = opts[:status] || STATUS_CODE["See Other"]
      body = %{You are being redirected, please follow <a href="#{target}">this link to: #{target}</a>!}

      Log.info("Redirect to '#{target}'")
      request[:redirected] = true
      throw(:redirect, [body, status, header])
    end

    def redirected?
      request[:redirected]
    end

    # redirect to the location the browser says it's coming from.

    def redirect_referer
      redirect request.referer
    end
    alias redirect_referrer redirect_referer
  end
end
