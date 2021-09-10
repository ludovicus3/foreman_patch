module ForemanPatch
  module WindowPatchingHelper

    def round_status(task, parent_task)
      return 'scheduled' if parent_task.nil?
      return (parent_task.result == 'cancelled' ? _('cancelled') : 'N/A') if task.nil?
      return task.state if task.state == 'running' || task.state == 'planned'

      task.result
    end

    def rounds(window)
      window.rounds.map do |round|
        {
          name: round.name,
          link: round_path(round),
          priority: round.priority,
          hostsCount: round.invocations.count,
          hostsLink: main_app.hosts_path(search: "patch_round_id = #{round.id}"),
          status: round_status(round.task, window.task),
          actions: []
        }
      end
    end

  end
end

