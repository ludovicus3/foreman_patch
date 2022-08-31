module ForemanPatch
  module WindowPatchingHelper

    def rounds(window)
      window.rounds.map do |round|
        {
          name: round.name,
          link: round_path(round),
          priority: round.priority,
          hostsCount: round.invocations.count,
          hostsLink: main_app.hosts_path(search: "patch_round_id = #{round.id}"),
          status: round.status,
          actions: []
        }
      end
    end

  end
end

