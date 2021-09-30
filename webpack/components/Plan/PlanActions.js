import { getURI } from 'foremanReact/common/urlHelpers';
import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { PLAN } from './PlanConstants';

const url = (id, action) => action.replace(':id', id);

export const getPlan = (id) => 
  withInterval(get({ key: PLAN, url: `/foreman_patch/api/plans/${id}` }), 1000);
export const editPlan = (id, data) =>
  withInterval(put({ key: PLAN, url: `/foreman_patch/api/plans/${id}`, data }), 1000);

export const getWindow = (id) =>
  withInterval(get({ key: PLAN, url: `/foreman_patch/api/plans/${id}/window_plans` }), 1000);
export const createWindow = (plan_id, data) =>
  withInterval(post({ key: PLAN, url: `/foreman_patch/api/window_plans/${id}`, data }), 1000);
export const editWindow = (id, data) =>
  withInterval(put({ key: PLAN, url: `/foreman_patch/api/window_plans/${id}`, data }), 1000);
export const destroyWindow = (id) =>
  withInterval(delete({ key: PLAN, url: `/foreman_patch/api/window_plans/${id}` }), 1000);
