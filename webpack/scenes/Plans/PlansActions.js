import { API_OPERATIONS, get, post } from 'foremanReact/redux/API';

import {
  CREATE_PLAN_KEY
} from './PlansConstants';
import { getResponseErrorMsgs } from '../../utils/helpers';

const planSuccessToast = (response) => {
  const { data: { name } } = response;
  return __(`Plan ${name} created`);
};

export const planErrorToast = (error) => {
  const message = getResponseErrorMsgs(error.response);
  return message;
}

export const createPlan = params => post({
  type: API_OPERATIONS.POST,
  key: CREATE_PLAN_KEY,
  url: api.getApiUrl('/plans'),
  params,
  successToast: response => planSuccessToast(response),
  errorToast: error => planErrorToast(error),
});
