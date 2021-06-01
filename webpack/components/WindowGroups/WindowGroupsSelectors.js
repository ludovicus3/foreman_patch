import {
    selectAPIStatus,
    selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { WINDOW_GROUPS } from './WindowGroupsConsts';

export const selectItems = state =>
  selectAPIResponse(state, WINDOW_GROUPS).groups || [];

export const selectAutoRefresh = state =>
  selectAPIResponse(state, WINDOW_GROUPS).autoRefresh;

export const selectStatus = state => selectAPIStatus(state, WINDOW_GROUPS);

