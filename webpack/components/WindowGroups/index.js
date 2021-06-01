import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import WindowGroups from './WindowGroups';

import {
    selectItems,
    selectStatus,
    selectAutoRefresh,
} from './WindowGroupsSelectors';
import { getData } from './WindowGroupsActions';
import { WINDOW_GROUPS } from './WindowGroupsConsts';

const WrappedWindowGroups = () => {
  const dispatch = useDispatch();
  const autoRefresh = useSelector(selectAutoRefresh);
  const items = useSelector(selectItems);
  const status = useSelector(selectStatus);

  useEffect(() => {
    dispatch(getData());

    return () => {
      dispatch(stopInterval(WINDOW_GROUPS));
    };
  }, [dispatch]);

  useEffect(() => {
    if (autoRefresh === 'false') {
      dispatch(stopInterval(WINDOW_GROUPS));
    }
  }, [autoRefresh, dispatch]);

  return <WindowGroups status={status} items={items} />;
};

export default WrappedWindowGroups;
