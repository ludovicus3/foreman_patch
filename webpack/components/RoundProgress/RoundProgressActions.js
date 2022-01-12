import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';

import { ROUND_PROGRESS } from './RoundProgressConstants';

export const getProgress = (round) => withInterval(get({ 
  key: ROUND_PROGRESS, 
  url: `/foreman_patch/api/rounds/${round}/status`,
}), 5000);
