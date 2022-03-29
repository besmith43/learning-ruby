Gem::Specification.new do |s|
  s.name = %q{assistance}
  s.version = "0.1.5"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ezra Zygmuntowicz, Sam Smoot, Sharon Rosner"]
  s.date = %q{2008-02-15}
  s.description = %q{light-weight application support}
  s.email = %q{ezmobius@gmail.com, ssmoot@gmail.com, ciconia@gmail.com}
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.files = ["COPYING", "README", "Rakefile", "spec/blank_spec.rb", "spec/connection_pool_spec.rb", "spec/extract_options.rb", "spec/inflector_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb", "spec/time_calculations_spec.rb", "spec/validation_spec.rb", "lib/assistance", "lib/assistance/blank.rb", "lib/assistance/connection_pool.rb", "lib/assistance/core_ext.rb", "lib/assistance/extract_options.rb", "lib/assistance/inflections.rb", "lib/assistance/inflector.rb", "lib/assistance/time_calculations.rb", "lib/assistance/validation.rb", "lib/assistance.rb", "CHANGELOG"]
  s.has_rdoc = true
  s.homepage = %q{http://assistance.rubyforge.org}
  s.rdoc_options = ["--quiet", "--title", "Assistance: light-weight application support", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/", "--exclude", "lib/assistance.rb"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{assistance}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{light-weight application support}
end
