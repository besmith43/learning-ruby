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
  CLIOption = Struct.new('CLIOption', :name, :default, :doc, :cli, :short)
  OPTIONS     = {}
  CLI_OPTIONS = []

  # DSL for specifying Globap options before initializing Global

  module GlobalDSL
    class << self

      # The method that takes the block containing the DSL, used like in
      # lib/ramaze/global.rb

      def option_dsl(&block)
        instance_eval(&block)
      end

      # Takes a doc-string and then the option as hash, another :cli key can
      # be given that will expose this option via the bin/ramaze.

      def o(doc, options = {})
        cli_given = options.has_key?(:cli)
        cli = options.delete(:cli)
        short = options.delete(:short)
        name, default = options.to_a.flatten

        if cli_given
          option = CLIOption.new(name, default, doc, cli, short)
          CLI_OPTIONS << option
        end

        OPTIONS.merge!(options)
      end
    end
  end
end
