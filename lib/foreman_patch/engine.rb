module ForemanPatch
  class Engine < ::Rails::Engine
    engine_name 'foreman_patch'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Add any db migrations
    initializer 'foreman_patch.load_app_instance_data' do |app|
      ForemanPatch::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_patch.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_patch do
        requires_foreman '>= 1.16'

        # Add permissions
        security_block :foreman_patch do
        end

      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanPatch::HostExtensions)
        HostsHelper.send(:include, ForemanPatch::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanPatch: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanPatch::Engine.load_seed
      end
    end

    initializer 'foreman_patch.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_patch'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
