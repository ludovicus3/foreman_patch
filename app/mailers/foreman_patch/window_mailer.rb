module ForemanPatch
  class WindowMailer < ApplicationMailer

    def results(options)
      @window = options[:window]

      set_local_for(user) do
        mail(to: user.mail, subject: (_("Patching Results for %s") % @window.name))
      end
    end

  end
end

