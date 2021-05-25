module ForemanPatch
  module WindowsHelper

    def window_group_move_buttons(group)
      return 'TODO'
      buttons = []

      groups_hash = group.window.window_groups.group_by(&:priority).to_hash

      buttons.push(link_to(_('Move up'), hash_for_move_window_group_path(id: group, direction: :up), method: :post)) unless priority == 1
      buttons.push(link_to(_('Move down'), hash_for_move_window_group_path(id: group, direction: :down), method: :post)) unless priority == last

      action_buttons(*buttons) unless buttons.empty?
    end

  end
end
