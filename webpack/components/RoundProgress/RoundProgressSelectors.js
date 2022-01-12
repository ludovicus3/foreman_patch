import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';

import { ROUND_PROGRESS } from './RoundProgressConstants';

const defaultProgress = {
  success: 0,
  warning: 0,
  failed: 0,
  running: 0,
  pending: 0,
  cancelled: 0,
};

export const selectProgress = state =>
  selectAPIResponse(state, ROUND_PROGRESS).progress || defaultProgress;

export const selectAutoRefresh = state =>
  !selectAPIResponse(state, ROUND_PROGRESS).complete;

export const selectStatus = state =>
  selectAPIStatus(state, ROUND_PROGRESS);
