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

require 'ramaze/helper'
require 'ramaze/template'
require 'ramaze/action'

require 'ramaze/controller/resolve'
require 'ramaze/controller/error'

module Ramaze

  # The Controller is responsible for combining and rendering actions.

  class Controller
    include Helper::Methods

    helper :redirect, :link, :sendfile, :flash, :cgi, :partial

    # Whether or not to map this controller on startup automatically

    trait[:automap] ||= true

    # Place to map the Controller to, this is something like '/' or '/foo'

    trait[:map] ||= nil

    # Caches patterns for the given path.

    trait :pattern_cache => Hash.new{|h,k| h[k] = Controller.pattern_for(k) }

    class << self
      # When Controller is subclassed the resulting class is placed in
      # Global.controllers and a new trait :actions_cached is set on it.

      def inherited controller
        controller.trait :actions_cached => {}
        Global.controllers << controller
        if map = controller.mapping
          Log.dev("mapping #{map} => #{controller}")
          Global.mapping[map] ||= controller
        end
      end

      # called from Ramaze.startup, adds Cache.actions and Cache.patterns, walks
      # all controllers subclassed so far and adds them to the Global.mapping if
      # they are not assigned yet.

      def startup options = {}
        Log.dev("found Controllers: #{Global.controllers.inspect}")

        check_path("Public root: '%s' doesn't exist", Global.public_root)
        check_path("Template root: '%s' doesn't exist", Global.template_root)

        require 'ramaze/controller/main' if Global.mapping.empty?

        Log.debug("mapped Controllers: #{Global.mapping.inspect}")
      end

      # checks paths for existance and logs a warning if it doesn't exist yet.

      def check_path(message, *paths)
        paths.each do |path|
          Log.warn(message % path) unless File.directory?(path)
        end
      end

      # if trait[:automap] is set and controller is not in Global.mapping yet
      # this will build a new default mapping-point, MainController is put
      # at '/' by default.

      def mapping
        global_mapping = Global.mapping.invert[self]
        return global_mapping if global_mapping
        if ancestral_trait[:automap]
          name = self.to_s.gsub('Controller', '').gsub('::', '/')
          name == 'Main' ? '/' : "/#{name.snake_case}"
        end
      end

      # Map Controller to the given syms or strings.
      # Replaces old mappings.
      # If you want to _add_ a mapping, just modify Global.mapping.

      def map(*syms)
        Global.mapping.delete_if{|k,v| v == self}

        syms.each do |sym|
          Global.mapping[sym.to_s] = self
        end
      end

      # Returns the Controller at a mapped path.

      def at(mapping)
        Global.mapping[mapping.to_s]
      end

      # Define a layout for all actions on this controller
      #
      # Example:
      #   class Foo < Ramaze::Controller
      #     layout :foo
      #   end
      #
      #  This defines the action :foo to be layout of the controller and will
      #  render the layout after any other action has been rendered, assigns
      #  @content to the result of the action and then goes on rendering
      #  the layout-action where @content may or may not be used, returning
      #  whatever the layout returns.

      def layout(*meth_or_hash)
        if meth_or_hash.empty?
          trait[:layout] ||= ( ancestral_trait[:layout] || {:all => nil, :deny => Set.new} ).dup
        else
          meth_or_hash = meth_or_hash.first
          if meth_or_hash.respond_to?(:to_hash)
            meth_or_hash.each do |layout_name, *actions|
              actions.flatten.each do |action|
                layout[action.to_s] = layout_name
              end
            end
          else
            layout[:all] = meth_or_hash
          end
        end
      end

      def deny_layout(*actions)
        actions.each do |action|
          layout[:deny] << action.to_s
        end
      end

      # Define a template_root for Controller, returns the current template_root
      # if no argument is given.
      # Runs every given path through Controller::check_path

      def template_root *args
        if args.empty?
          @template_root
        else
          check_path("#{self}.template_root: '%s' doesn't exist", *args)
          @template_root = args.flatten
        end
      end

      # This is used for template rerouting, takes action, optionally a
      # controller and action to route to.
      #
      # Usage:
      #   class MainController
      #     template :index, OtherController, :list
      #     template :foo, :bar
      #     template :bar, :file => '/absolute/path' 
      #     template :baz, :file => 'relative/path' 
      #     template :abc, :controller => OtherController
      #     template :xyz, :controller => OtherController, :action => 'list'
      #
      #     def index
      #       'will use template from OtherController#list'
      #     end
      #
      #     def foo
      #       'will use template from self#bar'
      #     end
      #
      #     def bar
      #       'will use template from /absolute/path'
      #     end
      #
      #     def baz
      #       'will use template from relative/path'
      #     end
      #
      #     def abc
      #       'will use template from OtherController#index'
      #     end
      #
      #     def xyz
      #       'will use template from OtherController#list'
      #     end
      #   end

      def template(this, *argv)
        case argv.first
          when Hash
            options, *ignored = argv
            controller = options[:controller] || options['controller']
            action = options[:action] || options['action']
            file = options[:file] || options['file']
            info = {}
            if file
              file = file.to_s
              unless Pathname(file).absolute?
                root = [template_root || Global.template_root].flatten.first
                file = File.join(root, file)
              end
              info[:file] = file
            else
              controller ||= self
              action = (action || 'index').to_s
              info[:controller] = controller
              info[:action] = action
            end
            trait "#{this}_template" => info
          else
            controller, action, *ignored = argv
            controller, action = self, controller unless action
            trait "#{this}_template" => {:controller => controller, :action => action} 
        end
      end

      def engine(name)
        name = Template.const_get(name)
      rescue NameError => ex
        Log.warn ex
        Log.warn "Try to use passed engine directly"
      ensure
        trait :engine => name
      end

      # Return Controller of current Action

      def current
        action = Action.current
        action.instance || action.controller
      end

      # Entering point for Dispatcher, first Controller::resolve(path) and then
      # renders the resulting Action.

      def handle path
        action = resolve(path)
        Thread.current[:controller] = action.controller
        action.render
      end
    end

    private

    # Simplistic render, rerouting to Controller.handle(*args)

    def render *args
      self.class.handle(*args)
    end
  end
end
