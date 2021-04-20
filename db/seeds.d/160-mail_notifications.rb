User.as(::User.anonymous_api_admin.login) do
  N_('Patch Window Results')

  notifications = [
    {
      name: :patch_window_results,
      description: N_('A summary of the results of a patch window'),
      mailer: 'ForemanPatch::WindowMailer',
      method: 'results',
      subscription_type: 'alert',
    }
  ]

  notifications.each do |notification|
    ::MailNotification.where(name: notification[:name]).first_or_create!(notification)
  end
end