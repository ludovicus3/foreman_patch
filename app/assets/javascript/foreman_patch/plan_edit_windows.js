function remove_window_plan(window_plan_id) {
  $('#windowPlan' + window_plan_id).remove();
}

function edit_window_plan(window_plan_id) {
  if (window_plan_id == null) form = null;
  else form = $('#windowPlans #windowPlanHidden' + window_plan_id);
  //show_window_plan_modal();
}
