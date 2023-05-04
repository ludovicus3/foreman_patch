module ForemanPatch
  class Engine < ::Rails::Engine
    engine_name 'foreman_patch'
    isolate_namespace ForemanPatch

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman_patch.register_plugin', :before => :finisher_hook do |_app|
      require 'foreman_patch/plugin'
      Apipie.configuration.checksum_path += ['/foreman_patch/api/']
    end

    initializer 'foreman_patch.configure_assets', group: :assets do
      SETTINGS[:foreman_patch] = { assets: { precompile: ['foreman_patch.css'] } }
    end

    # Add any db migrations
    initializer 'foreman_patch.load_app_instance_data' do |app|
      ForemanPatch::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_patch.mount_engine', before: :sooner_routes_load do |app|
      app.routes_reloader.paths << "#{ForemanPatch::Engine.root}/config/routes/mount_engine.rb"
      app.routes_reloader.paths << "#{ForemanPatch::Engine.root}/config/api_routes.rb"
      app.routes_reloader.paths.unshift("#{ForemanPatch::Engine.root}/config/routes/overrides.rb")
    end

    initializer 'foreman_patch.load_default_settings', before: :load_config_initializers do |_app|
      require_dependency File.expand_path('../../../app/models/setting/patching.rb', __FILE__)
    end

    initializer 'foreman_patch.require_dynflow', before: 'foreman_tasks.initialize_dynflow' do |_app|
      ::ForemanTasks.dynflow.require!
      ::ForemanTasks.dynflow.config.eager_load_paths << File.join(ForemanPatch::Engine.root, 'app/lib/actions/foreman_patch')
    end

    initializer 'foreman_patch.helpers' do |_app|
      ActionView::Base.include ForemanPatch::HostsHelper
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      # Model extensions
      ::Host::Managed.send(:include, ForemanPatch::Concerns::HostManagedExtensions)

      # Controller extensions      
      ::HostsController.include ForemanPatch::Concerns::HostsControllerExtensions

      # Api Controller extensions
      ::Api::V2::HostsController.include ForemanPatch::Concerns::Api::V2::HostsControllerExtensions
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

  def self.table_name_prefix
    'foreman_patch_'
  end

  def self.use_relative_model_naming
    true
  end

  def self.register_rex_features
    RemoteExecutionFeature.register(
      :power_action,
      N_('Power Action'),
      description: N_('Power Action'),
      provided_inputs: 'action',
      host_action_button: false
    )
  end
end
