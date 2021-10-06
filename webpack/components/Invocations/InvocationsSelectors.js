import {
    selectAPIStatus,
    selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { INVOCATIONS } from './InvocationsConsts';

export const selectItems = state =>
  selectAPIResponse(state, INVOCATIONS).invocations || [];

export const selectAutoRefresh = state =>
  selectAPIResponse(state, INVOCATIONS).autoRefresh;

export const selectStatus = state => selectAPIStatus(state, INVOCATIONS);

