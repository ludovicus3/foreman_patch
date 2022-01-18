module ForemanPatch
  module PlansHelper

    def plan_actions(plan)
      links = []

      links << link_to(_('Create Window'), new_plan_window_plan_path(plan_id: @plan.id),
                       class: 'btn btn-default',
                       title: _('Create a new window for this plan'))

      links << link_to(_('Edit'), edit_plan_path(@plan),
                       class: 'btn btn-default',
                       title: _('Edit this plan'))

      links << link_to(_('Run'), iterate_plan_path(@plan),
                       class: 'btn btn-primary',
                       title: _('Manually Iterate Plan'),
                       method: :post)

      links
    end

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

  end
end
