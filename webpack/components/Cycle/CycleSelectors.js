import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { CYCLE } from './CycleConstants';

export const selectCycle = state => (selectAPIResponse(state, CYCLE) || {});

export const selectStatus = state => selectAPIStatus(state, CYCLE);

