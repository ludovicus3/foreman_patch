import {
    selectAPIStatus,
    selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { ROUNDS } from './RoundsConsts';

export const selectItems = state =>
  selectAPIResponse(state, ROUNDS).rounds || [];

export const selectAutoRefresh = state =>
  selectAPIResponse(state, ROUNDS).autoRefresh;

export const selectStatus = state => selectAPIStatus(state, ROUNDS);

