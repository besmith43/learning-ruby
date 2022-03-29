# -*- encoding: utf-8 -*-
# stub: tracer 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "tracer".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Keiju ISHITSUKA".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-04-01"
  s.description = "Outputs a source level execution trace of a Ruby program.".freeze
  s.email = ["keiju@ruby-lang.org".freeze]
  s.files = [".gitignore".freeze, ".travis.yml".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/tracer.rb".freeze, "lib/tracer/version.rb".freeze, "tracer.gemspec".freeze]
  s.homepage = "https://github.com/ruby/tracer".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "Outputs a source level execution trace of a Ruby program.".freeze

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
