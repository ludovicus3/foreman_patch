import { getURL } from 'foremanReact/common/urlHelpers';
import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { INVOCATION } from './InvocationConsts';

const url = getURI().addQuery('format', 'json');
export const getData = () => 
  withInterval(get({ key: INVOCATION, url }), 1000);
