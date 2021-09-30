import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { PLAN } from './PlanConstants';

export const selectPlan = state => selectAPIResponse(state, PLAN) || {};

export const selectStatus = state => selectAPIStatus(state, PLAN);
