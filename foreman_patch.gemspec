require File.expand_path('../lib/foreman_patch/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_patch'
  s.version     = ForemanPatch::VERSION
  s.license     = 'GPL-3.0'
  s.date        = Date.today.to_s
  s.authors     = ['Jason Galens']
  s.email       = ['bogey.jlg@gmail.com']
  s.homepage    = 'https://github.com/ludovicus3/foreman_patch'
  s.summary     = 'Foreman Plugin for Managing Patching'
  # also update locale/gemspec.rb
  s.description = 'Foreman Plugin for Managing Patching.'
  s.required_ruby_version = '~> 2.5'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json'] + Dir['public/{assets,webpack}/foreman_patch/**/*']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'katello', '~> 3.18'
  s.add_dependency 'foreman-tasks', '>= 3.0', '< 5.0'
  s.add_dependency 'foreman_remote_execution', '~> 4.2'
  s.add_dependency 'dynflow', '~> 1.4'

end
