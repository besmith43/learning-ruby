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
# This file contains functions for finding relations for English words. It
# requires the Ruby-WordNet module to be installed; if it is not installed,
# calling the functions defined by this file will raise NotImplemented
# exceptions if called. Requiring this file adds functions and constants to the
# Linguistics::EN module.
#
# == Synopsis
#
#   # Test to be sure the WordNet module loaded okay.
#   Linguistics::EN.has_wordnet?
#   # => true
#  
#   # Fetch the default synset for the word "balance"
#   "balance".synset
#   # => #<WordNet::Synset:0x40376844 balance (noun): "a state of equilibrium"
#    (derivations: 3, antonyms: 1, hypernyms: 1, hyponyms: 3)>
#  
#   # Fetch the synset for the first verb sense of "balance"
#   "balance".en.synset( :verb )
#   # => #<WordNet::Synset:0x4033f448 balance, equilibrate, equilibrize, equilibrise
#   (verb): "bring into balance or equilibrium; "She has to balance work and her
#   domestic duties"; "balance the two weights"" (derivations: 7, antonyms: 1,
#   verbGroups: 2, hypernyms: 1, hyponyms: 5)>
#  
#   # Fetch the second noun sense
#   "balance".en.synset( 2, :noun )
#   # => #<WordNet::Synset:0x404ebb24 balance (noun): "a scale for weighing; depends
#   on pull of gravity" (hypernyms: 1, hyponyms: 5)>
#  
#   # Fetch the second noun sense's hypernyms (more-general words, like a superclass)
#   "balance".en.synset( 2, :noun ).hypernyms
#   # => [#<WordNet::Synset:0x404e5620 scale, weighing machine (noun): "a measuring
#   instrument for weighing; shows amount of mass" (derivations: 2, hypernyms: 1,
#   hyponyms: 2)>]
#  
#   # A simpler way of doing the same thing:
#   "balance".en.hypernyms( 2, :noun )
#   # => [#<WordNet::Synset:0x404e5620 scale, weighing machine (noun): "a measuring
#   instrument for weighing; shows amount of mass" (derivations: 2, hypernyms: 1,
#   hyponyms: 2)>]
#  
#   # Fetch the first hypernym's hypernyms
#   "balance".en.synset( 2, :noun ).hypernyms.first.hypernyms
#   # => [#<WordNet::Synset:0x404c60b8 measuring instrument, measuring system,
#   measuring device (noun): "instrument that shows the extent or amount or quantity
#   or degree of something" (hypernyms: 1, hyponyms: 83)>]
#  
#   # Find the synset to which both the second noun sense of "balance" and the
#   # default sense of "shovel" belong.
#   ("balance".en.synset( 2, :noun ) | "shovel".en.synset)
#   # => #<WordNet::Synset:0x40473da4 instrumentality, instrumentation (noun): "an
#   artifact (or system of artifacts) that is instrumental in accomplishing some
#   end" (derivations: 1, hypernyms: 1, hyponyms: 13)>
#  
#   # Fetch just the words for the other kinds of "instruments"
#   "instrument".en.hyponyms.collect {|synset| synset.words}.flatten
#   # => ["analyzer", "analyser", "cautery", "cauterant", "drafting instrument",
#   "extractor", "instrument of execution", "instrument of punishment", "measuring
#   instrument", "measuring system", "measuring device", "medical instrument",
#   "navigational instrument", "optical instrument", "plotter", "scientific
#   instrument", "sonograph", "surveying instrument", "surveyor's instrument",
#   "tracer", "weapon", "arm", "weapon system", "whip"]
# 
# 
# == Authors
# 
# * Michael Granger <ged@FaerieMUD.org>
# 
# == Copyright
#
# Copyright (c) 2003 The FaerieMUD Consortium. All rights reserved.
# 
# This module is free software. You may use, modify, and/or redistribute this
# software under the terms of the Perl Artistic License. (See
# http://language.perl.com/misc/Artistic.html)
# 
# == Version
#
#  $Id: wordnet.rb,v 1.3 2003/09/14 11:28:02 deveiant Exp $
# 

module Linguistics::EN

	@has_wordnet		= false
	@wn_error		= nil
	@wn_lexicon		= nil

	# Load WordNet and open the lexicon if possible, saving the error that
	# occurs if anything goes wrong.
	begin
		require 'wordnet'
		@has_wordnet = true
	rescue LoadError => err
		@wn_error = err
	end


	#################################################################
	###	M O D U L E   M E T H O D S
	#################################################################
	class << self

		### Returns +true+ if WordNet was loaded okay
		def has_wordnet? ; @has_wordnet; end

		### If #haveWordnet? returns +false+, this can be called to fetch the
		### exception which was raised when WordNet was loaded.
		def wn_error ; @wn_error; end

		### The instance of the WordNet::Lexicon used for all Linguistics WordNet
		### functions.
		def wn_lexicon
			if @wn_error
				raise NotImplementedError,
					"WordNet functions are not loaded: %s" %
					@wn_error.message
			end

			@wn_lexicon ||= WordNet::Lexicon::new
		end

		### Make a function that calls the method +meth+ on the synset of an input
		### word.
		def def_synset_function( meth )
			(class << self; self; end).instance_eval do
				define_method( meth ) {|*args|
					word, pos, sense = *args
					raise ArgumentError,
						"wrong number of arguments (0 for 1)" unless word
					sense ||= 1

					syn = synset( word.to_s, pos, sense )
					return syn.nil? ? nil : syn.send( meth )
				}
			end
		end
	end



	#################################################################
	###	W O R D N E T   I N T E R F A C E
	#################################################################

	###############
	module_function
	###############

	### Look up the synset associated with the given word or collocation in the
	### WordNet lexicon and return a WordNet::Synset object.
	def synset( word, pos=nil, sense=1 )
		lex = Linguistics::EN::wn_lexicon
		if pos.is_a?( Fixnum )
			sense = pos
			pos = nil
		end
		postries = pos ? [pos] : [:noun, :verb, :adjective, :adverb, :other]
		syn = nil

		postries.each do |pos|
			break if syn = lex.lookupSynsets( word.to_s, pos, sense )
		end

		return syn
	end


	### Look up all the synsets associated with the given word or collocation in
	### the WordNet lexicon and return an Array of WordNet::Synset objects. If
	### +pos+ is +nil+, return synsets for all parts of speech.
	def synsets( word, pos=nil )
		lex = Linguistics::EN::wn_lexicon
		postries = pos ? [pos] : [:noun, :verb, :adjective, :adverb, :other]
		syns = []

		postries.each {|pos|
			syns << lex.lookupSynsets( word.to_s, pos )
		}

		return syns.flatten.compact
	end


	# Returns definitions and/or example sentences as a String.
	def_synset_function :gloss

	# Returns definitions and/or example sentences as an Array.
	def_synset_function :glosses

	# Return nouns or verbs that have the same hypernym as the receiver.
	def_synset_function :coordinates

	# Returns the Array of synonyms contained in the synset for the receiver.
	def_synset_function :words
	def_synset_function :synonyms

	# Returns the name of the lexicographer file that contains the raw data for
	# the receiver.
	def_synset_function :lex_info

	# :TODO: Finish these comments, and figure out how the hell to get the
	# methods to show up in RDoc.
	def_synset_function :frames


	# Returns the synsets for the receiver's antonyms, if any. Ex:
	# 'opaque'.en.synset.antonyms
	#   ==> [#<WordNet::Synset:0x010ca614/454927 clear (adjective): "free
	#        from cloudiness; allowing light to pass through; "clear water";
	#        "clear plastic bags"; "clear glass"; "the air is clear and clean""
	#        (similarTos: 6, attributes: 1, derivations: 2, antonyms: 1,
	#        seeAlsos: 1)>]
	def_synset_function :antonyms

	def_synset_function :hypernyms
    def_synset_function :instanceHypernyms
	def_synset_function :entailment
	def_synset_function :hyponyms
    def_synset_function :instanceHyponyms
	def_synset_function :causes
	def_synset_function :verbgroups
	def_synset_function :similarTo
	def_synset_function :participles
	def_synset_function :pertainyms
	def_synset_function :attributes
	def_synset_function :derivedFrom
	def_synset_function :seeAlso
	def_synset_function :functions

	def_synset_function :meronyms
	def_synset_function :memberMeronyms
	def_synset_function :stuffMeronyms
	def_synset_function :portionMeronyms
	def_synset_function :componentMeronyms
	def_synset_function :featureMeronyms
	def_synset_function :phaseMeronyms
	def_synset_function :placeMeronyms

	def_synset_function :holonyms
	def_synset_function :memberHolonyms
	def_synset_function :stuffHolonyms
	def_synset_function :portionHolonyms
	def_synset_function :componentHolonyms
	def_synset_function :featureHolonyms
	def_synset_function :phaseHolonyms
	def_synset_function :placeHolonyms

	def_synset_function :domains
	def_synset_function :categoryDomains
	def_synset_function :regionDomains
	def_synset_function :usageDomains

	def_synset_function :members
	def_synset_function :categoryMembers
	def_synset_function :regionMembers
	def_synset_function :usageMembers


end # module Linguistics::EN

