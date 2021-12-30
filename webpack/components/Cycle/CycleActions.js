import { APIActions } from 'foremanReact/redux/API/APIActions';
//import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { CYCLE, WINDOW } from './CycleConstants';

const getCycleUrl = (id) => `/foreman_patch/api/cycles/${id}`;
const getWindowUrl = (id) => `/foreman_patch/api/windows/${id}`;

export const getCycle = (id) => APIActions.get({ key: CYCLE, url: getCycleUrl(id) });

export const deleteWindow = (id) => APIActions.delete({ key: WINDOW, url: getWindowUrl(id)});

export const moveWindow = (object) => APIActions.put({
  key: WINDOW,
  url: getWindowUrl(object.id),
  params: {
    window: {
      start_at: object.start.toISOString(),
      end_by: object.end.toISOString(),
    }
  }
});
