import {
  selectAPIStatus,
  selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { INVOCATION } from './InvocationConsts';

export const selectInvocation = state =>
  selectAPIResponse(state, INVOCATION) || {};

export const selectState = state =>
  selectAPIResponse(state, INVOCATION).state;

export const selectStatus = state =>
  selectAPIStatus(state, INVOCATION);
