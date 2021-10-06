import { getURI } from 'foremanReact/common/urlHelpers';
import { get } from 'foremanReact/redux/API';
import { withInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { INVOCATIONS } from './InvocationsConsts';

const url = getURI().addQuery('format', 'json');
export const getData = () => 
  withInterval(get({ key: INVOCATIONS, url }), 1000);
