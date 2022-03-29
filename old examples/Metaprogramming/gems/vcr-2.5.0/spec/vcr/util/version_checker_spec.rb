#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'spec_helper'

module VCR
  describe VersionChecker do
    it 'raises an error if the major version is too low' do
      checker = VersionChecker.new('foo', '0.7.3', '1.0.0', '1.1')
      expect { checker.check_version! }.to raise_error(Errors::LibraryVersionTooLowError)
    end

    it 'raises an error if the minor version is too low' do
      checker = VersionChecker.new('foo', '1.0.99', '1.1.3', '1.2')
      expect { checker.check_version! }.to raise_error(Errors::LibraryVersionTooLowError)
    end

    it 'raises an error if the patch version is too low' do
      checker = VersionChecker.new('foo', '1.0.8', '1.0.10', '1.2')
      expect { checker.check_version! }.to raise_error(Errors::LibraryVersionTooLowError)
    end

    it 'prints a warning if the major version is too high' do
      checker = VersionChecker.new('foo', '2.0.0', '1.0.0', '1.1')
      Kernel.should_receive(:warn).with(/may not work with this version/)
      checker.check_version!
    end

    it 'prints a warning if the minor version is too high' do
      checker = VersionChecker.new('foo', '1.2.0', '1.0.0', '1.1')
      Kernel.should_receive(:warn).with(/may not work with this version/)
      checker.check_version!
    end

    it 'does not raise an error or print a warning when the major version is between the min and max' do
      checker = VersionChecker.new('foo', '2.0.0', '1.0.0', '3.0')
      Kernel.should_not_receive(:warn)
      checker.check_version!
    end

    it 'does not raise an error or print a warning when the min_patch is 0.6.5, the max_minor is 0.7 and the version is 0.7.3' do
      checker = VersionChecker.new('foo', '0.7.3', '0.6.5', '0.7')
      Kernel.should_not_receive(:warn)
      checker.check_version!
    end
  end
end

