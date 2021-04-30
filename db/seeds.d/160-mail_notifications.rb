User.as(::User.anonymous_api_admin.login) do
  N_('Patch Window Results')

  notifications = [
    {
      name: :patch_group_initiated,
      description: N_('Notification that a patch group is about to start patching'),
      mailer: 'ForemanPatch::GroupMailer',
      method: 'initiated',
      subscription_type: 'alert',
    },
    {
      name: :patch_group_completed,
      description: N_('Notification that a patch group has completed patching'),
      mailer: 'ForemanPatch::GroupMailer',
      method: 'completed',
      subscription_type: 'alert',
    },
    {
      name: :patch_invocation_failure,
      description: N_('Notification of an error in the host patching process'),
      mailer: 'ForemanPatch::InvocationMailer',
      method: 'failure',
      subscription_type: 'alert',
    }
  ]

  notifications.each do |notification|
    ::MailNotification.where(name: notification[:name]).first_or_create!(notification)
  end
end
