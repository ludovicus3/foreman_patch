module ForemanPatch
  class InvocationMailer < ApplicationMailer
    add_template_helper JobInvocationOutputHelper
    add_template_helper RemoteExecutionHelper

    def failure(options)
      user = options[:user]

      @host = options[:host]
      @output = options[:output]
      @line_counter = 0

      set_locale_for(user) do
        mail(to: user.mail, subject: (_("Patching Failure for %s") % @host.name))
      end
    end
  end
end

