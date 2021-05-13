module ForemanPatch
  class GroupMailer < ApplicationMailer

    def initiated(options)
      user = options[:user]

      @group = options[:group].name
      @hosts = options[:group].invocations.map { |invocation| invocation.host.name }

      set_locale_for(user) do
        mail(to: user.mail, subject: (_("%s Patching Initiated") % @group))
      end
    end

    def completed(options)
      user = options[:user]

      @group = options[:group].name
      @total = options[:group].invocations.count
      @successes = options[:group].invocations.select(&:succeeded?).map { |invocation| invocation.host.name }
      @failures = options[:group].invocations.select(&:failed?).map { |invocation| invocation.host.name }
       

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

