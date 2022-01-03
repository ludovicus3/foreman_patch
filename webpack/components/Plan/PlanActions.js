import { APIActions } from 'foremanReact/redux/API';
import { PLAN, WINDOW } from './PlanConstants';

export const getPlan = (id) => APIActions.get({ key: PLAN, url: `/foreman_patch/api/plans/${id}` });

export const moveWindow = ({id, ...object}) => APIActions.put({
  key: WINDOW,
  url: `/foreman_patch/api/window_plans/${id}`,
  params: {
    window_plan: object,
  }
});
