import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import Invocations from './Invocations';

import {
    selectItems,
    selectStatus,
    selectAutoRefresh,
} from './InvocationsSelectors';
import { getData } from './InvocationsActions';
import { INVOCATIONS } from './InvocationsConsts';

const WrappedInvocations = () => {
  const dispatch = useDispatch();
  const autoRefresh = useSelector(selectAutoRefresh);
  const items = useSelector(selectItems);
  const status = useSelector(selectStatus);

  useEffect(() => {
    dispatch(getData());

    return () => {
      dispatch(stopInterval(INVOCATIONS));
    };
  }, [dispatch]);

  useEffect(() => {
    if (autoRefresh === 'false') {
      dispatch(stopInterval(INVOCATIONS));
    }
  }, [autoRefresh, dispatch]);

  return <Invocations status={status} items={items} />;
};

export default WrappedInvocations;
