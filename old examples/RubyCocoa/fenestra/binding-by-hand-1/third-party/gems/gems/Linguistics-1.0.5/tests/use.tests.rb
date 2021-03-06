#!/usr/bin/ruby -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#
# Unit test for the 'use' function of the Linguistics module.
# $Id: use.tests.rb 95 2007-06-13 05:25:38Z deveiant $
#
# Copyright (c) 2003 The FaerieMUD Consortium.
# 

unless defined? Linguistics::TestCase
	testsdir = File::dirname( File::expand_path( __FILE__ ) )
	$LOAD_PATH.unshift testsdir unless $LOAD_PATH.include?( testsdir )

	require 'lingtestcase'
end


### This test suite tests the language-installation function of the Linguistics
### module.
module Linguistics
class UseTestCase < Linguistics::TestCase

	LanguageCodes = [ :en, :EN, 'en', 'EN', 'En', 'eN' ]
	BogusLanguageCodes = [ :zz, :ry, :qi ]
	MissingLanguageCodes = [ :ja, :fr, :es ]

	TestArray = %w{stone stick hammer stone lantern}
	TestString = "banner"
	TestNumber = 5

	def test_00_UseEnglish
		printTestHeader "Linguistics: Use <language>"

		# Test the only (currently) valid codes
		LanguageCodes.each do |code|
			assert_nothing_raised {
				Linguistics::use( code )
			}
		end

		# Test bogus codes
		BogusLanguageCodes.each do |code|
			assert_raises( RuntimeError ) {
				Linguistics::use( code )
			}
		end

		# Test valid, but missing languages (might fail for implementors of new
		# languages).
		MissingLanguageCodes.each do |code|
			assert_raises( LoadError ) {
				Linguistics::use( code )
			}
		end

	end


	def test_10_InflectorMethod
		printTestHeader "Linguistics: Inflector method (core classes)"
		rval = nil

		# This shouldn't be necessary, but it's here for completeness
		Linguistics::use( :en )

		[ TestArray, TestString, TestNumber ].each do |obj|
			debug_msg "obj.class.instance_variables = %s" %
				obj.class.instance_variables.inspect

			assert_respond_to obj, :en
			assert_nothing_raised {
				rval = obj.en
			}
			assert_kind_of Linguistics::LanguageProxyClass, rval
		end
	end


	def test_20_SpecifyClasses
		printTestHeader "Linguistics: Extend specific classes"
		
		assert_nothing_raised( "One class, not in an array" ) {
			Linguistics::use( :en, :classes => Symbol )
		}
		assert_respond_to :foo, :en

		assert_nothing_raised( "One class, in an array" ) {
			Linguistics::use( :en, :classes => [IO] )
		}
		assert_respond_to $stderr, :en

		assert_nothing_raised( "Two classes, in an Array" ) {
			Linguistics::use( :en, :classes => [Class, Range] )
		}
		assert_respond_to Array, :en
		assert_respond_to( (1..5), :en )
	end

end
end
