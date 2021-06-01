import { getURI } from 'foremanReact/common/urlHelpers';
import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { WINDOW_GROUPS } from './WindowGroupsConsts';

const url = getURI().addQuery('format', 'json');
export const getData = () => 
  withInterval(get({ key: WINDOW_GROUPS, url }), 1000);
