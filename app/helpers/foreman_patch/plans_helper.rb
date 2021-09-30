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

    def plan_last_window_day(plan)
      (plan.frequency.to_i / ActiveSupport::Duration::SECONDS_PER_DAY) - 1
    end

    def plan_to_args(plan)
      {
        id: plan.id,
        name: plan.name,
        description: plan.description,
        start: plan.start_date.iso8601,
        end: plan.end_date.iso8601,
        interval: plan.interval,
        units: plan.units,
        correction: plan.correction,
        activeCount: plan.active_count,
        windows: plan.window_plans.map { |w| window_to_args(w) },
      }
    end

    def window_to_args(window)
      {
        id: window.id,
        link: edit_window_plan_path(window),
        name: window.name,
        description: window.description,
        start: window.start_at.iso8601,
        end: window.end_by.iso8601,
      }
    end

  end
end
