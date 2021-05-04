Pagelets::Manager.with_key "hosts/_form" do |mgr|
  mgr.add_pagelet :main_tab_fields,
    partial: 'overrides/patch_groups/host_patch_group_select',
    priority: 90
end

