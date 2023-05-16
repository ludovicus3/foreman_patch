import {
    selectAPIStatus,
    selectAPIResponse,
} from 'foremanReact/redux/API/APISelectors';
import { PLANS } from './PlansTableConsts';

export const selectPlans = state => selectAPIResponse(state, PLANS).results || [];

export const selectTotal = state => selectAPIResponse(state, PLANS).total || 0;

export const selectStatus = state => selectAPIStatus(state, PLANS);
