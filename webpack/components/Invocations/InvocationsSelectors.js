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
export const selectSearch = state =>
  selectAPIResponse(state, INVOCATIONS).search || '';
export const selectPage = state =>
  selectAPIResponse(state, INVOCATIONS).page || 1;
export const selectPerPage = state =>
  selectAPIResponse(state, INVOCATIONS).per_page;

export const selectAutoRefresh = state =>
  selectItems(state).some(item => (item.result === 'pending'));

export const selectStatus = state => selectAPIStatus(state, INVOCATIONS);

export const selectIntervalExists = state =>
  selectDoesIntervalExist(state, INVOCATIONS);

