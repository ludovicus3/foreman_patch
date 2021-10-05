User.as_anonymous_admin do
  RemoteExecutionFeature.without_auditing do
    if Rails.env.test? || Foreman.in_rake?
      ForemanPatch.register_rex_features
    end

    JobTemplate.without_auditing do
      module_template = JobTemplate.find_by(name: 'Power Action - SSH Default')
      if module_template && !Rails.env.test? && Setting[:remote_execution_sync_templates]
        module_template.sync_feature('power_action')
        module_template.organizations << Organization.unscoped.all if module_template.organizations.empty?
        module_template.locations << Location.unscoped.all if module_template.locations.empty?
      end
    end
  end
end
