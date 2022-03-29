# -*- encoding: utf-8 -*-
# stub: ffi 1.15.4 java lib

Gem::Specification.new do |s|
  s.name = "ffi".freeze
  s.version = "1.15.4"
  s.platform = "java".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/ffi/ffi/issues", "changelog_uri" => "https://github.com/ffi/ffi/blob/master/CHANGELOG.md", "documentation_uri" => "https://github.com/ffi/ffi/wiki", "mailing_list_uri" => "http://groups.google.com/group/ruby-ffi", "source_code_uri" => "https://github.com/ffi/ffi/", "wiki_uri" => "https://github.com/ffi/ffi/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Wayne Meissner".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIC/DCCAeSgAwIBAgIBAjANBgkqhkiG9w0BAQsFADAkMSIwIAYDVQQDDBl0cmF2\naXMtY2kvREM9ZHVtbXkvREM9b3JnMB4XDTIxMDUyMjA3MjgxNFoXDTIyMDUyMjA3\nMjgxNFowJDEiMCAGA1UEAwwZdHJhdmlzLWNpL0RDPWR1bW15L0RDPW9yZzCCASIw\nDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK+5uh+zqCXKho0zXIaLmJD6YDpa\nl07nJ+PQFcMBYgsKA2ip01THj3DVYwP/va6hYgqPmxEJB3tsEthKnHVHm0dgqqg/\ngfyDFU0ZfbSYKeNlZQRIdddKPc6dNbmtY2gBWFt6YOZnBccsgJmSUAbh0a9xhVbm\nqAStn/q7eq9iW9+12AB9HM+QCWrsCAXEHGGNENDAK9HtHwBs4KsneiIQY5rd/Mzs\nIi25XXnDUa1NjC4u/mMuJXBpWLw2rEAQkzEFQBZR0W0ehm9Mi4TokhLy/QH8GRaH\n0KADzpk1cxuOrEBIhy6ISQs7g/tI6YTePAmDMTsodov02FZCcMpoxOifpFkCAwEA\nAaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFOTn5ek+QtcI\ng+ZglIvRPAPGoXvLMA0GCSqGSIb3DQEBCwUAA4IBAQCkYZdWhRDXD2i1x+i9ldUt\nseNbE+9n742DLgTeQoGyrGO8qabcfM/DBC5iohpFfXa6tJ/ufT2G4xwJq9CVgkY9\nJQWZfxrqzRwY69Rq7MA5lAJ9/HpzkjEiZjPO0jYEhy7iznnhWCzmUFFO9++hH5Mj\nSviDbWEcg72gtdu53KTk+dlWFRMK/zVXX2LsxdJ8+oL/HrPUKIPaMuvaPiOxZ85i\n6k/UaTHptue0Rj8i8Xv3VmPvYrk3LacY/rmUvJAv+rrd5vBxYI8HZ+VPZD+IcLVL\nbF2Y4mTGMgJ2+MB9E838+Rh6U7sDsKfP5d9102VfpDaueM4jxBHxeY7g/UIyYS/1\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2021-09-01"
  s.description = "Ruby FFI library".freeze
  s.email = "wmeissner@gmail.com".freeze
  s.files = ["CHANGELOG.md".freeze, "COPYING".freeze, "Gemfile".freeze, "LICENSE".freeze, "LICENSE.SPECS".freeze, "README.md".freeze, "Rakefile".freeze, "ffi.gemspec".freeze, "lib/ffi.rb".freeze, "lib/ffi/abstract_memory.rb".freeze, "lib/ffi/autopointer.rb".freeze, "lib/ffi/buffer.rb".freeze, "lib/ffi/callback.rb".freeze, "lib/ffi/data_converter.rb".freeze, "lib/ffi/enum.rb".freeze, "lib/ffi/errno.rb".freeze, "lib/ffi/ffi.rb".freeze, "lib/ffi/io.rb".freeze, "lib/ffi/library.rb".freeze, "lib/ffi/managedstruct.rb".freeze, "lib/ffi/memorypointer.rb".freeze, "lib/ffi/platform.rb".freeze, "lib/ffi/platform/aarch64-darwin/types.conf".freeze, "lib/ffi/platform/aarch64-freebsd/types.conf".freeze, "lib/ffi/platform/aarch64-freebsd12/types.conf".freeze, "lib/ffi/platform/aarch64-linux/types.conf".freeze, "lib/ffi/platform/aarch64-openbsd/types.conf".freeze, "lib/ffi/platform/arm-freebsd/types.conf".freeze, "lib/ffi/platform/arm-freebsd12/types.conf".freeze, "lib/ffi/platform/arm-linux/types.conf".freeze, "lib/ffi/platform/i386-cygwin/types.conf".freeze, "lib/ffi/platform/i386-darwin/types.conf".freeze, "lib/ffi/platform/i386-freebsd/types.conf".freeze, "lib/ffi/platform/i386-freebsd12/types.conf".freeze, "lib/ffi/platform/i386-gnu/types.conf".freeze, "lib/ffi/platform/i386-linux/types.conf".freeze, "lib/ffi/platform/i386-netbsd/types.conf".freeze, "lib/ffi/platform/i386-openbsd/types.conf".freeze, "lib/ffi/platform/i386-solaris/types.conf".freeze, "lib/ffi/platform/i386-windows/types.conf".freeze, "lib/ffi/platform/ia64-linux/types.conf".freeze, "lib/ffi/platform/mips-linux/types.conf".freeze, "lib/ffi/platform/mips64-linux/types.conf".freeze, "lib/ffi/platform/mips64el-linux/types.conf".freeze, "lib/ffi/platform/mipsel-linux/types.conf".freeze, "lib/ffi/platform/mipsisa32r6-linux/types.conf".freeze, "lib/ffi/platform/mipsisa32r6el-linux/types.conf".freeze, "lib/ffi/platform/mipsisa64r6-linux/types.conf".freeze, "lib/ffi/platform/mipsisa64r6el-linux/types.conf".freeze, "lib/ffi/platform/powerpc-aix/types.conf".freeze, "lib/ffi/platform/powerpc-darwin/types.conf".freeze, "lib/ffi/platform/powerpc-linux/types.conf".freeze, "lib/ffi/platform/powerpc-openbsd/types.conf".freeze, "lib/ffi/platform/powerpc64-linux/types.conf".freeze, "lib/ffi/platform/powerpc64le-linux/types.conf".freeze, "lib/ffi/platform/riscv64-linux/types.conf".freeze, "lib/ffi/platform/s390-linux/types.conf".freeze, "lib/ffi/platform/s390x-linux/types.conf".freeze, "lib/ffi/platform/sparc-linux/types.conf".freeze, "lib/ffi/platform/sparc-solaris/types.conf".freeze, "lib/ffi/platform/sparc64-linux/types.conf".freeze, "lib/ffi/platform/sparcv9-openbsd/types.conf".freeze, "lib/ffi/platform/sparcv9-solaris/types.conf".freeze, "lib/ffi/platform/x86_64-cygwin/types.conf".freeze, "lib/ffi/platform/x86_64-darwin/types.conf".freeze, "lib/ffi/platform/x86_64-dragonflybsd/types.conf".freeze, "lib/ffi/platform/x86_64-freebsd/types.conf".freeze, "lib/ffi/platform/x86_64-freebsd12/types.conf".freeze, "lib/ffi/platform/x86_64-haiku/types.conf".freeze, "lib/ffi/platform/x86_64-linux/types.conf".freeze, "lib/ffi/platform/x86_64-msys/types.conf".freeze, "lib/ffi/platform/x86_64-netbsd/types.conf".freeze, "lib/ffi/platform/x86_64-openbsd/types.conf".freeze, "lib/ffi/platform/x86_64-solaris/types.conf".freeze, "lib/ffi/platform/x86_64-windows/types.conf".freeze, "lib/ffi/pointer.rb".freeze, "lib/ffi/struct.rb".freeze, "lib/ffi/struct_by_reference.rb".freeze, "lib/ffi/struct_layout.rb".freeze, "lib/ffi/struct_layout_builder.rb".freeze, "lib/ffi/tools/const_generator.rb".freeze, "lib/ffi/tools/generator.rb".freeze, "lib/ffi/tools/generator_task.rb".freeze, "lib/ffi/tools/struct_generator.rb".freeze, "lib/ffi/tools/types_generator.rb".freeze, "lib/ffi/types.rb".freeze, "lib/ffi/union.rb".freeze, "lib/ffi/variadic.rb".freeze, "lib/ffi/version.rb".freeze, "rakelib/ffi_gem_helper.rb".freeze, "samples/getlogin.rb".freeze, "samples/getpid.rb".freeze, "samples/gettimeofday.rb".freeze, "samples/hello.rb".freeze, "samples/inotify.rb".freeze, "samples/pty.rb".freeze, "samples/qsort.rb".freeze]
  s.homepage = "https://github.com/ffi/ffi/wiki".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rdoc_options = ["--exclude=ext/ffi_c/.*\\.o$".freeze, "--exclude=ffi_c\\.(bundle|so)$".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "Ruby FFI".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rake-compiler-dock>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rake-compiler-dock>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake-compiler-dock>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
  end
end
