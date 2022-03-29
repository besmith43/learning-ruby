Gem::Specification.new do |s|
  s.name = %q{assert2}
  s.version = "0.3.2"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Phlip"]
  s.cert_chain = nil
  s.date = %q{2008-05-24}
  s.email = %q{phlip2005@gmail.com}
  s.files = ["lib/ruby_reflector.rb", "lib/assert2.rb"]
  s.homepage = %q{http://assert2.rubyforge.org/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{assert2}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{An assertion that reflects its block, with all intermediate values}

  s.add_dependency(%q<rubynode>, ["> 0.0.0"])
end
