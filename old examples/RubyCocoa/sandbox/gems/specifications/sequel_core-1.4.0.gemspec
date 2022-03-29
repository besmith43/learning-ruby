Gem::Specification.new do |s|
  s.name = %q{sequel_core}
  s.version = "1.4.0"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Aman Gupta"]
  s.cert_chain = nil
  s.date = %q{2008-04-08}
  s.default_executable = %q{sequel}
  s.description = %q{The Database Toolkit for Ruby: Core Library and Adapters}
  s.email = %q{themastermind1@gmail.com}
  s.executables = ["sequel"]
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.files = ["COPYING", "README", "Rakefile", "bin/sequel", "spec/adapters", "spec/array_keys_spec.rb", "spec/core_ext_spec.rb", "spec/core_sql_spec.rb", "spec/database_spec.rb", "spec/dataset_spec.rb", "spec/migration_spec.rb", "spec/pretty_table_spec.rb", "spec/rcov.opts", "spec/schema_generator_spec.rb", "spec/schema_spec.rb", "spec/sequelizer_spec.rb", "spec/spec.opts", "spec/spec_config.rb.example", "spec/spec_helper.rb", "spec/worker_spec.rb", "spec/adapters/informix_spec.rb", "spec/adapters/mysql_spec.rb", "spec/adapters/oracle_spec.rb", "spec/adapters/postgres_spec.rb", "spec/adapters/sqlite_spec.rb", "lib/sequel_core.rb", "lib/sequel_core", "lib/sequel_core/adapters", "lib/sequel_core/array_keys.rb", "lib/sequel_core/core_ext.rb", "lib/sequel_core/core_sql.rb", "lib/sequel_core/database.rb", "lib/sequel_core/dataset.rb", "lib/sequel_core/dataset", "lib/sequel_core/exceptions.rb", "lib/sequel_core/migration.rb", "lib/sequel_core/model.rb", "lib/sequel_core/pretty_table.rb", "lib/sequel_core/schema.rb", "lib/sequel_core/schema", "lib/sequel_core/worker.rb", "lib/sequel_core/adapters/adapter_skeleton.rb", "lib/sequel_core/adapters/ado.rb", "lib/sequel_core/adapters/db2.rb", "lib/sequel_core/adapters/dbi.rb", "lib/sequel_core/adapters/informix.rb", "lib/sequel_core/adapters/jdbc.rb", "lib/sequel_core/adapters/mysql.rb", "lib/sequel_core/adapters/odbc.rb", "lib/sequel_core/adapters/odbc_mssql.rb", "lib/sequel_core/adapters/openbase.rb", "lib/sequel_core/adapters/oracle.rb", "lib/sequel_core/adapters/postgres.rb", "lib/sequel_core/adapters/sqlite.rb", "lib/sequel_core/dataset/callback.rb", "lib/sequel_core/dataset/convenience.rb", "lib/sequel_core/dataset/sequelizer.rb", "lib/sequel_core/dataset/sql.rb", "lib/sequel_core/schema/generator.rb", "lib/sequel_core/schema/sql.rb", "CHANGELOG"]
  s.has_rdoc = true
  s.homepage = %q{http://sequel.rubyforge.org}
  s.rdoc_options = ["--quiet", "--title", "Sequel: The Database Toolkit for Ruby", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/", "--exclude", "lib/sequel_core.rb"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{sequel}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{The Database Toolkit for Ruby: Core Library and Adapters}

  s.add_dependency(%q<metaid>, ["> 0.0.0"])
  s.add_dependency(%q<assistance>, [">= 0.1"])
  s.add_dependency(%q<RubyInline>, [">= 3.6.6"])
  s.add_dependency(%q<ParseTree>, [">= 2.1.1"])
  s.add_dependency(%q<ruby2ruby>, ["> 0.0.0"])
end
