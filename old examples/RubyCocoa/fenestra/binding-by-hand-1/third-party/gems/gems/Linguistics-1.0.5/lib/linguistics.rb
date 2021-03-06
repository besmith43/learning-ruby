#!/usr/bin/ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# 
# linguistics.rb -- provides an interface for extending core Ruby classes with
# linguistic methods.
# 
# == Synopsis
# 
#   require 'linguistics'
#	Linguistics::use( :en )
#	MyClass::extend( Linguistics )
#
# == Authors
# 
# * Michael Granger <ged@FaerieMUD.org>
# 
# == Copyright
#
# Copyright (c) 2003-2005 The FaerieMUD Consortium. All rights reserved.
# 
# This module is free software. You may use, modify, and/or redistribute this
# software under the terms of the Perl Artistic License. (See
# http://language.perl.com/misc/Artistic.html)
# 
# == Version
#
#  $Id: linguistics.rb 95 2007-06-13 05:25:38Z deveiant $
# 

require 'linguistics/iso639'

### A language-independent framework for adding linguistics functions to Ruby
### classes.
module Linguistics 

	### Class constants

	# Subversion revision
	SVNRev = %q$Rev: 95 $

	# Subversion ID
	SVNid = %q$Id: linguistics.rb 95 2007-06-13 05:25:38Z deveiant $

	# Language module implementors should do something like:
	#   Linguistics::DefaultLanguages.push( :ja ) # or whatever
	# so that direct requiring of a language module sets the default.
	DefaultLanguages = []

	# The list of Classes to add linguistic behaviours to.
	DefaultExtClasses = [String, Numeric, Array]


	#################################################################
	###	I N F L E C T O R   C L A S S   F A C T O R Y
	#################################################################

	### A class which is inherited from by proxies for classes being extended
	### with one or more linguistic interfaces. It provides on-the-fly creation
	### of linguistic methods when the <tt>:installProxy</tt> option is passed
	### to the call to Linguistics#use.
	class LanguageProxyClass

		### Class instance variable + accessor. Contains the module which knows
		### the specifics of the language the languageProxy class is providing
		### methods for.
		@langmod = nil
		class << self
			attr_accessor :langmod
		end


		### Create a new LanguageProxy for the given +receiver+.
		def initialize( receiver )
			@receiver = receiver
		end


		######
		public
		######

		### Overloaded to take into account the proxy method.
		def respond_to?( sym )
			self.class.langmod.respond_to?( sym ) || super
		end


		### Autoload linguistic methods defined in the module this object's
		### class uses for inflection.
		def method_missing( sym, *args, &block )
			return super unless self.class.langmod.respond_to?( sym )

			self.class.module_eval %{
				def #{sym}( *args, &block )
					self.class.langmod.#{sym}( @receiver, *args, &block )
				end
			}, "{Autoloaded: " + __FILE__ + "}", __LINE__

			self.method( sym ).call( *args, &block )
		end


		### Returns a human-readable representation of the languageProxy for
		### debugging, logging, etc.
		def inspect
			"<%s languageProxy for %s object %s>" % [
				self.class.langmod.language,
				@receiver.class.name,
				@receiver.inspect,
			]
		end

	end


	### Extend the specified target object with one or more language proxy
	### methods, each of which provides access to one or more linguistic methods
	### for that language.
	def self::extend_object( obj )
		case obj
		when Class
			# $stderr.puts "Extending %p" % obj if $DEBUG
			self::install_language_proxy( obj )
		else
			sclass = (class << obj; self; end)
			# $stderr.puts "Extending a object's metaclass: %p" % obj if $DEBUG
			self::install_language_proxy( sclass )
		end

		super
	end


	### Extend the including class with linguistics proxy methods.
	def self::included( mod )
		# $stderr.puts "Including Linguistics in %p" % mod if $DEBUG
		mod.extend( self ) unless mod == Linguistics
	end


	### Make an languageProxy class that encapsulates all of the inflect operations
	### using the given language module.
	def self::make_language_proxy( mod )
		# $stderr.puts "Making language proxy for mod %p" % [mod]
		Class::new( LanguageProxyClass ) {
			@langmod = mod
		}
	end


	### Install the language proxy
	def self::install_language_proxy( klass, languages=DefaultLanguages )
		languages.replace( DefaultLanguages ) if languages.empty?

		# Create an languageProxy class for each language specified
		languages.each do |lang|
			# $stderr.puts "Extending the %p class with %p" %
			#	[ klass, lang ] if $DEBUG

			# Load the language module (skipping to the next if it's already
			# loaded), make a languageProxy class that delegates to it, and
			# figure out what the languageProxy method will be called.
			mod = load_language( lang.to_s.downcase )
			ifaceMeth = mod.name.downcase.sub( /.*:/, '' )
			languageProxyClass = make_language_proxy( mod )

			# Install a hash for languageProxy classes and an accessor for the
			# hash if it's not already present.
			if !klass.class_variables.include?( "@@__languageProxy_class" )
				klass.module_eval %{
					@@__languageProxy_class = {}
					def self::__languageProxy_class; @@__languageProxy_class; end
				}, __FILE__, __LINE__
			end

			# Merge the current languageProxy into the hash
			klass.__languageProxy_class.merge!( ifaceMeth => languageProxyClass )

			# Set the language-code proxy method for the class unless it has one
			# already
			unless klass.instance_methods(true).include?( ifaceMeth )
				klass.module_eval %{
					def #{ifaceMeth}
						@__#{ifaceMeth}_languageProxy ||=
							self.class.__languageProxy_class["#{ifaceMeth}"].
							new( self )
					end
				}, __FILE__, __LINE__
			end
		end
	end



	### Install a regular proxy method in the given klass that will delegate
	### calls to missing method to the languageProxy for the given +language+.
	def self::install_delegator_proxy( klass, langcode )
		raise ArgumentError, "Missing langcode" if langcode.nil?

		# Alias any currently-extant
		if klass.instance_methods( false ).include?( "method_missing" )
			klass.module_eval %{
				alias_method :__orig_method_missing, :method_missing
			}
		end

		# Add the #method_missing method that auto-installs delegator methods
		# for methods supported by the linguistic proxy objects.
		klass.module_eval %{
			def method_missing( sym, *args, &block )

				# If the linguistic delegator answers the message, install a
				# delegator method and call it.
				if self.send( :#{langcode} ).respond_to?( sym )

					# $stderr.puts "Installing linguistic delegator method \#{sym} " \
					#	"for the '#{langcode}' proxy"
					self.class.module_eval %{
						def \#{sym}( *args, &block )
							self.#{langcode}.\#{sym}( *args, &block )
						end
					}
					self.method( sym ).call( *args, &block )

				# Otherwise either call the overridden proxy method if there is
				# one, or just let our parent deal with it.
				else
					if self.respond_to?( :__orig_method_missing )
						return self.__orig_method_missing( sym, *args, &block )
					else
						super( sym, *args, &block )
					end
				end
			end
		}
	end



	#################################################################
	###	L A N G U A G E - I N D E P E N D E N T   F U N C T I O N S
	#################################################################


	### Handle auto-magic usage
	def self::const_missing( sym )
		load_language( sym.to_s.downcase )
	end


	###############
	module_function
	###############

	### Add linguistics functions for the specified languages to Ruby's core
	### classes. The interface to all linguistic functions for a given language
	### is through a method which is the same the language's international 2- or
	### 3-letter code (ISO 639). You can also specify a Hash of configuration
	### options which control which classes are extended:
	###
	### [<b>:classes</b>]
	###   Specify the classes which are to be extended. If this is not specified,
	###   the Class objects in Linguistics::DefaultExtClasses (an Array) are
	###   extended.
	### [<b>:installProxy</b>]
	###   Install a proxy method in each of the classes which are to be extended
	###   which will search for missing methods in the languageProxy for the
	###   language code specified as the value. This allows linguistics methods
	###   to be called directly on extended objects directly (e.g.,
	###   12.en.ordinal becomes 12.ordinal). Obviously, methods which would
	###   collide with the object's builtin methods will need to be invoked
	###   through the languageProxy. Any existing proxy methods in the extended
	###   classes will be preserved.
	def use( *languages )
		config = {}
		config = languages.pop if languages.last.is_a?( Hash )

		classes = config.key?( :classes ) ? config[:classes] : DefaultExtClasses
		classes = [ classes ] unless classes.is_a?( Array )

		# Install the languageProxy in each class.
		classes.each {|klass|

			# Create an languageProxy class for each installed language
			install_language_proxy( klass, languages )

			# Install the delegator proxy if configured
			if config[:installProxy]
				case config[:installProxy]
				when Symbol
					langcode = config[:installProxy]
				when String
					langcode = config[:installProxy].intern
				when TrueClass
					langcode = languages[0] || DefaultLanguages[0] || :en
				else
					raise ArgumentError,
						"Unexpected value %p for :installProxy" %
						config[:installProxy]
				end

				install_delegator_proxy( klass, langcode )
			end
		}
	end



	### Support Lingua::EN::Inflect-style globals in a threadsafe way by using
	### Thread-local variables.

	### Set the default count for all unspecified plurals to +val+. Setting is
	### local to calling thread.
	def num=( val )
		Thread.current[:persistent_count] = val
	end
	alias_method :NUM=, :num=

	### Get the default count for all unspecified plurals. Setting is local to
	### calling thread.
	def num
		Thread.current[:persistent_count]
	end
	alias_method :NUM, :num

	
	### Set the 'classical pluralizations' flag to +val+. Setting is local to
	### calling thread.
	def classical=( val )
		Thread.current[:classical_plurals] = val
	end

	### Return the value of the 'classical pluralizations' flag. Setting is
	### local to calling thread.
	def classical?
		Thread.current[:classical_plurals] ? true : false
	end


	#######
	private
	#######

	### Try to load the module that implements the given language, returning
	### the Module object if successful.
	def self::load_language( lang )
		raise "Unknown language code '#{lang}'" unless
			LanguageCodes.key?( lang )

		# Sort all the codes for the specified language, trying the 2-letter
		# versions first in alphabetical order, then the 3-letter ones
		msgs = []
		mod = LanguageCodes[ lang ][:codes].sort {|a,b|
			(a.length <=> b.length).nonzero? ||
			(a <=> b)
		}.each do |code|
			unless Linguistics::const_defined?( code.upcase )
				begin
					require "linguistics/#{code}"
				rescue LoadError => err
					msgs << "Tried 'linguistics/#{code}': #{err.message}\n"
					next
				end
			end

			break Linguistics::const_get( code.upcase ) if
				Linguistics::const_defined?( code.upcase )
		end

		if mod.is_a?( Array )
			raise LoadError,
				"Failed to load language extension %s:\n%s" %
				[ lang, msgs.join ]
		end
		return mod
	end

end # class linguistics

