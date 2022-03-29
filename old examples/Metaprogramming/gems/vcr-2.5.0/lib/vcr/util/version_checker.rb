#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
module VCR
  # @private
  class VersionChecker
    def initialize(library_name, library_version, min_patch_level, max_minor_version)
      @library_name, @library_version = library_name, library_version
      @min_patch_level, @max_minor_version = min_patch_level, max_minor_version

      @major,     @minor,     @patch     = parse_version(library_version)
      @min_major, @min_minor, @min_patch = parse_version(min_patch_level)
      @max_major, @max_minor             = parse_version(max_minor_version)

      @comparison_result = compare_version
    end

    def check_version!
      raise_too_low_error if too_low?
      warn_about_too_high if too_high?
    end

  private

    def too_low?
      @comparison_result == :too_low
    end

    def too_high?
      @comparison_result == :too_high
    end

    def raise_too_low_error
      raise Errors::LibraryVersionTooLowError,
        "You are using #{@library_name} #{@library_version}. " +
        "VCR requires version #{version_requirement}."
    end

    def warn_about_too_high
      Kernel.warn "You are using #{@library_name} #{@library_version}. " +
                  "VCR is known to work with #{@library_name} #{version_requirement}. " +
                  "It may not work with this version."
    end

    def compare_version
      case
        when @major < @min_major then :too_low
        when @major > @max_major then :too_high
        when @major > @min_major then :ok
        when @minor < @min_minor then :too_low
        when @minor > @max_minor then :too_high
        when @minor > @min_minor then :ok
        when @patch < @min_patch then :too_low
      end
    end

    def version_requirement
      ">= #{@min_patch_level}, < #{@max_major}.#{@max_minor + 1}"
    end

    def parse_version(version)
      version.split('.').map { |v| v.to_i }
    end
  end
end

