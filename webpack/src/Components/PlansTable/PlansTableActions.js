import API from 'foremanReact/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { PLANS } from './PlansTableConsts';

export const getData = (url) =>
    withInterval(API.get({ key: PLANS, url }), 1000);
