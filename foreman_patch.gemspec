require File.expand_path('../lib/foreman_patch/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_patch'
  s.version     = ForemanPatch::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Jason Galens']
  s.email       = ['bogey.jlg@gmail.com']
  s.homepage    = 'https://github.com/ludovicus3/foreman_patch'
  s.summary     = 'Foreman Plugin for Managing Patching'
  # also update locale/gemspec.rb
  s.description = 'Foreman Plugin for Managing Patching.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
