require File.join([File.dirname(__FILE__),'lib','todo/version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'todo'
  s.version = '0.0.1'

  # ... 
  

  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = %w(
bin/todo
lib/todo/version.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','todo.rdoc']
  s.rdoc_options << '--title' << 'todo' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'todo'
  s.add_development_dependency('aruba', '~> 0.5.3')
  s.add_development_dependency('mocha', '0.14.0')
  s.add_development_dependency('rake')
  s.add_dependency('gli')
  s.add_dependency('rainbow')
end
