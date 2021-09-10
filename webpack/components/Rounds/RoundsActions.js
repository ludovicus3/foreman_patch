import { getURI } from 'foremanReact/common/urlHelpers';
import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { ROUNDS } from './RoundsConsts';

const url = getURI().addQuery('format', 'json');
export const getData = () => 
  withInterval(get({ key: ROUNDS, url }), 1000);
