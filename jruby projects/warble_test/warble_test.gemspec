Gem::Specification.new do |s|
  s.name            = 'warble_test'
  s.version         = '1.0.0'
  s.authors         = ['Blake Smith']
  s.date            = '2022-02-05'
  s.description     = 'Warble Test Program'
  s.email           = ['besmith43@gmail.com']
  s.require_paths   = ['lib', 'bin']
  s.summary         = 'Jruby Jar test application with swing GUI interface'
  s.files           = Dir.glob("{bin,lib}/**/*")
  s.executables     = ['hello_gui.rb']
end
