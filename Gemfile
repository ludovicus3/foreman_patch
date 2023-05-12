if ENV.fetch('BUNDLE_FOREMAN', '1') == '0'
    source 'https://rubygems.org'
else
    foreman_path = Dir['./foreman', '../foreman', '../../foreman']
    foreman_path.map! { |path| File.join(path, 'Gemfile') }
    foreman_gemfile = foreman_path.detect { |path| File.exist?(path) }
    raise 'Foreman has not been found!' unless foreman_gemfile

    foreman_gemfile = File.expand_path(foreman_gemfile)
    eval_gemfile foreman_gemfile

    temporary_deletes = %w[theforeman-rubocop]
    temporary_deletes.concat(%w[foreman_patch]).each do |dep_name|
        dep = dependencies.detect { |d| d.name == dep_name }
        dependencies.delete(dep) if dep
    end
end

gemspec

gem 'rspec-rails', '~> 4.0.1', groups: %i[development test]
gem 'theforeman-rubocop', '~> 0.1.1', groups: %i[development rubocop]