Gem::Specification.new do |s|
  s.name = %q{Shoulda}
  s.version = "1.1.1"

  s.specification_version = 1 if s.respond_to? :specification_version=

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Tammer Saleh"]
  s.cert_chain = nil
  s.date = %q{2008-02-27}
  s.default_executable = %q{convert_file_to_shoulda}
  s.description = %q{== FEATURES/PROBLEMS:  * wrap your tests in nested context blocks to keep them readable and dry * write test names in english, not with_a_bunch_of_underscores * fully compatible with your existing Test::Unit tests * makes writing test macros simple as pie  == SYNOPSIS:  class UserTest << Test::Unit  context "A User instance" do setup do @user = User.find(:first) end  should "return its full name" do assert_equal 'John Doe', @user.full_name end}
  s.email = %q{tsaleh@thoughtbot.com}
  s.executables = ["convert_file_to_shoulda"]
  s.extra_rdoc_files = ["Manifest.txt", "README.txt"]
  s.files = ["Manifest.txt", "README.txt", "Rakefile", "bin/convert_file_to_shoulda", "lib/shoulda.rb", "lib/proc_extensions.rb", "test/test_shoulda.rb"]
  s.has_rdoc = true
  s.homepage = %q{    by Tammer Saleh, Thoughtbot, Inc.}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{shoulda}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Testing library built on top of Test::Unit}
  s.test_files = ["test/test_shoulda.rb"]
end
