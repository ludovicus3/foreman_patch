module ForemanPatch
  module WindowPlansHelper

    def plan_length(plan)
      (plan.start_date - plan.end_date).to_i
    end

    def time_local_f(f, attr, options = {})
      react_form_input('time', f, attr, options)
    end

  end
end
