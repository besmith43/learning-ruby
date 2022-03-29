Gem::Specification.new do |s|
  s.name = %q{Linguistics}
  s.version = "1.0.5"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Granger, Martin Chase"]
  s.autorequire = %q{linguistics}
  s.cert_chain = nil
  s.date = %q{2007-06-12}
  s.email = %q{ged@FaerieMUD.org, stillflame@FaerieMUD.org}
  s.files = ["Artistic", "experiments/randobjlist.rb", "install.rb", "lib/linguistics/en.rb", "lib/linguistics/iso639.rb", "lib/linguistics.rb", "lib/linguistics/en/infinitive.rb", "lib/linguistics/en/linkparser.rb", "lib/linguistics/en/wordnet.rb", "MANIFEST", "README", "README.english", "redist/crosscase.rb", "test.rb", "tests/en/conjunction.tests.rb", "tests/en/inflect.tests.rb", "tests/lingtestcase.rb", "tests/use.tests.rb", "TODO", "utils.rb", "ChangeLog"]
  s.homepage = %q{http://www.deveiate.org/projects/Linguistics/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{A generic, language-neutral framework for extending Ruby objects with linguistic methods.}
end
