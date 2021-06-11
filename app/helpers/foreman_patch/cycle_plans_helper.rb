module ForemanPatch
  module CyclePlansHelper

    def plan_windows(cycle_plan, day)
      day = (day - cycle_plan.next_cycle_date).to_i

      cycle_plan.window_plans.select do |window|
        window.start_day == day
      end
    end

    def plan_window_actions(window)
      actions = []

      actions << link_to(_('Edit'), edit_window_plan_path(window))
      actions << link_to(_('Delete'), hash_for_window_plan_path(id: window), data: { confirm: _('Are you sure?') }, action: :destroy)

      actions
    end
  end
end
