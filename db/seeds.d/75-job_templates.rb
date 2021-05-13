User.as(::User.anonymous_api_admin.login) do
  JobTemplate.without_auditing do
    Dir[File.join("#{ForemanPatch::Engine.root}/app/views/templates/**/*.erb")].each do |template|
      sync = !Rails.env.test? && Setting[:remote_execution_sync_templates]

      if JobTemplate.respond_to?('import_raw!')
        template = JobTemplate.import_raw!(File.read(template), default: true, lock: true, update: sync)
      else
        template = JobTemplate.import!(File.read(template), default: true, lock: true, update: sync)
      end

      template.organizations << Organization.unscoped.all if template&.organizations&.empty?
      template.organizations << Location.unscoped.all if template&.locations&.empty?
    end
  end    
end
