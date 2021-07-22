module ForemanPatch
  class CycleMailer < ApplicationMailer
    helper ForemanPatch::TicketHelper

    def planned(options)
      @user = options[:user]

      @cycle = options[:cycle]

      set_locale_for(@user) do
        mail(to: @user.mail, subject: (_("Patching Cycle Planned")))
      end
    end

  end
end

