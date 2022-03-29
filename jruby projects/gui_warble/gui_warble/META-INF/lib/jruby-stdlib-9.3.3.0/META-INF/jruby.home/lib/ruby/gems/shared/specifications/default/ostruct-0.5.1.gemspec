# -*- encoding: utf-8 -*-
# stub: ostruct 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ostruct".freeze
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marc-Andre Lafortune".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-12-07"
  s.description = "Class to build custom data structures, similar to a Hash.".freeze
  s.email = ["ruby-core@marc-andre.ca".freeze]
  s.files = [".gitignore".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/ostruct.rb".freeze, "ostruct.gemspec".freeze]
  s.homepage = "https://github.com/ruby/ostruct".freeze
  s.licenses = ["Ruby".freeze, "BSD-2-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0".freeze)
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "Class to build custom data structures, similar to a Hash.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
