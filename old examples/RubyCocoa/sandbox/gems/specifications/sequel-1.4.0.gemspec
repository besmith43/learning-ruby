Gem::Specification.new do |s|
  s.name = %q{sequel}
  s.version = "1.4.0"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Evans"]
  s.cert_chain = nil
  s.date = %q{2008-04-08}
  s.description = %q{The Database Toolkit for Ruby: Model Classes}
  s.email = %q{code@jeremyevans.net}
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.files = ["COPYING", "README", "Rakefile", "doc/rdoc", "spec/associations_spec.rb", "spec/base_spec.rb", "spec/caching_spec.rb", "spec/deprecated_relations_spec.rb", "spec/eager_loading_spec.rb", "spec/hooks_spec.rb", "spec/model_spec.rb", "spec/plugins_spec.rb", "spec/rcov.opts", "spec/record_spec.rb", "spec/schema_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/validations_spec.rb", "lib/sequel.rb", "lib/sequel_model.rb", "lib/sequel_model", "lib/sequel_model/associations.rb", "lib/sequel_model/base.rb", "lib/sequel_model/caching.rb", "lib/sequel_model/eager_loading.rb", "lib/sequel_model/hooks.rb", "lib/sequel_model/plugins.rb", "lib/sequel_model/pretty_table.rb", "lib/sequel_model/record.rb", "lib/sequel_model/schema.rb", "lib/sequel_model/validations.rb", "CHANGELOG"]
  s.has_rdoc = true
  s.homepage = %q{http://sequel.rubyforge.org}
  s.rdoc_options = ["--quiet", "--title", "Sequel: The Database Toolkit for Ruby", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/", "--exclude", "lib/sequel_model.rb"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{sequel}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{The Database Toolkit for Ruby: Model Classes}

  s.add_dependency(%q<assistance>, [">= 0.1.2"])
  s.add_dependency(%q<sequel_core>, ["= 1.4.0"])
end
