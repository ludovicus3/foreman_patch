import {
  selectAPIStatus,
  selectAPIError,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { STATUS } from 'foremanReact/constants';
import { CREATE_PLAN_KEY } from '../PlansConstants';

export const selectCreatePlan = state =>
  selectAPIResponse(state, CREATE_PLAN_KEY) || {};

export const selectCreatePlanStatus = state =>
  selectAPIStatus(state, CREATE_PLAN_KEY) || STATUS.PENDING;

export const selectCreatePlanError = state =>
  selectAPIError(state, CREATE_PLAN_KEY);

