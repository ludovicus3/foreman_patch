module ForemanPatch
  module PlansHelper

    def plan_windows(plan, day)
      day = (day - plan.start_date).to_i

      plan.window_plans.select do |window|
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
