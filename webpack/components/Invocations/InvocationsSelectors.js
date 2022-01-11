import {
    selectAPIStatus,
    selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { selectDoesIntervalExist } from 'foremanReact/redux/middlewares/IntervalMiddleware/IntervalSelectors';

import { INVOCATIONS } from './InvocationsConstants';

export const selectItems = state =>
  selectAPIResponse(state, INVOCATIONS).results || [];
export const selectTotal = state =>
  selectAPIResponse(state, INVOCATIONS).total || 0;

export const selectAutoRefresh = state =>
  selectItems(state).some(item => (item.result === 'pending')) || true;

export const selectStatus = state => selectAPIStatus(state, INVOCATIONS);

export const selectIntervalExists = state =>
  selectDoesIntervalExist(state, INVOCATIONS);

