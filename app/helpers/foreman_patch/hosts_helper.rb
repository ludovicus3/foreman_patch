module ForemanPatch
  module HostsHelper

    def patch_groups_for_host(host, options)
      include_blank = options.fetch(:include_blank, nil)
      if include_blank == true
        include_blank = '<option></option>'
      end

      group_options = ForemanPatch::Group.all.map do |group|
        selected = host.group.try(:id) == group.id ? 'selected' : ''
        %(<option #{selected} value="#{group.id}">#{h(group.name)}</option>)
      end

      group_options = group_options.join
      group_options.insert(0, include_blank) if include_blank
      group_options.html_safe
    end

  end
end
