require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "fileutils"
include FileUtils

##############################################################################
# Configuration
##############################################################################
NAME = "assistance"
VERS = "0.1.5"
CLEAN.include ["**/.*.sw?", "pkg/*", ".config", "doc/*", "coverage/*"]
RDOC_OPTS = [
  "--quiet", 
  "--title", "Assistance: light-weight application support",
  "--opname", "index.html",
  "--line-numbers", 
  "--main", "README",
  "--inline-source"
]

##############################################################################
# RDoc
##############################################################################
task :doc => [:rdoc]

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "doc/rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.main = "README"
  rdoc.title = "Assistance: light-weight application support"
  rdoc.rdoc_files.add ["README", "COPYING", "lib/assistance.rb", "lib/**/*.rb"]
end

task :doc_rforge => [:doc]

desc "Update docs and upload to rubyforge.org"
task :doc_rforge do
  sh %{scp -r doc/rdoc/* ciconia@rubyforge.org:/var/www/gforge-projects/assistance}
end

##############################################################################
# Gem packaging
##############################################################################
desc "Packages up Assistance."
task :default => [:package]
task :package => [:clean]

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.rubyforge_project = NAME
  s.version = VERS
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.rdoc_options += RDOC_OPTS + 
    ["--exclude", "^(examples|extras)\/", "--exclude", "lib/assistance.rb"]
  s.summary = "light-weight application support"
  s.description = s.summary
  s.author = "Ezra Zygmuntowicz, Sam Smoot, Sharon Rosner"
  s.email = "ezmobius@gmail.com, ssmoot@gmail.com, ciconia@gmail.com"
  s.homepage = "http://assistance.rubyforge.org"
  s.required_ruby_version = ">= 1.8.4"

  s.files = %w(COPYING README Rakefile) + Dir.glob("{doc,spec,lib}/**/*")

  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

##############################################################################
# installation & removal
##############################################################################
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :install_no_docs do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS} --no-rdoc --no-ri}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

task :tag do
  cwd = FileUtils.pwd
  sh %{cd .. && svn copy #{cwd} tags/#{NAME}-#{VERS} && svn commit -m "#{NAME}-#{VERS} tag." tags}
end

##############################################################################
# gem and rdoc release
##############################################################################
task :release => [:package] do
  sh %{rubyforge login}
  sh %{rubyforge add_release #{NAME} #{NAME} #{VERS} pkg/#{NAME}-#{VERS}.tgz}
  sh %{rubyforge add_file #{NAME} #{NAME} #{VERS} pkg/#{NAME}-#{VERS}.gem}
end

##############################################################################
# specs
##############################################################################
require "spec/rake/spectask"

desc "Run specs with coverage"
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList["spec/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
  t.rcov_opts  = File.read("spec/rcov.opts").split("\n")
  t.rcov = true
end

desc "Run specs without coverage"
Spec::Rake::SpecTask.new("spec_no_cov") do |t|
  t.spec_files = FileList["spec/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
end

