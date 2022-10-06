module ForemanPatch
  class GroupMailer < ApplicationMailer

    def initiated(options)
      user = options[:user]

      @group = options[:group].name
      @hosts = options[:group].invocations.pluck(:name)

      set_locale_for(user) do
        mail(to: user.mail, subject: (_("%s Patching Initiated") % @group))
      end
    end

    def completed(options)
      user = options[:user]

      @group = options[:group].name
      @total = options[:group].invocations.count
      @successes = options[:group].invocations.successful.pluck(:name)
      @warnings = options[:group].invocations.warning.pluck(:name)
      @failures = options[:group].invocations.failed.pluck(:name)

      set_locale_for(user) do
        mail(to: user.mail, subject: (_("%s Patching Completed") % @group))
      end
    end

    def report(options)
      user = options[:user]

      @group = options[:group].name
      @result = options[:result]

      set_locale_for(user) do
        mail(to: user.mail, subject: (_("%s Preliminary Report") % @group))
      end
    end
  end
end

