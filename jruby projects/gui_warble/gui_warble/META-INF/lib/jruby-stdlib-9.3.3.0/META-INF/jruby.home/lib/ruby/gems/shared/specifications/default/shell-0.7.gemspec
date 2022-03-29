# -*- encoding: utf-8 -*-
# stub: shell 0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "shell".freeze
  s.version = "0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Keiju ISHITSUKA".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-12-04"
  s.description = "An idiomatic Ruby interface for common UNIX shell commands.".freeze
  s.email = ["keiju@ruby-lang.org".freeze]
  s.files = [".gitignore".freeze, ".travis.yml".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/shell.rb".freeze, "lib/shell/builtin-command.rb".freeze, "lib/shell/command-processor.rb".freeze, "lib/shell/error.rb".freeze, "lib/shell/filter.rb".freeze, "lib/shell/process-controller.rb".freeze, "lib/shell/system-command.rb".freeze, "lib/shell/version.rb".freeze, "shell.gemspec".freeze]
  s.homepage = "https://github.com/ruby/shell".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "An idiomatic Ruby interface for common UNIX shell commands.".freeze

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
