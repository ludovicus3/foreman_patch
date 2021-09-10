import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import Rounds from './Rounds';

import {
    selectItems,
    selectStatus,
    selectAutoRefresh,
} from './RoundsSelectors';
import { getData } from './RoundsActions';
import { ROUNDS } from './RoundsConsts';

const WrappedRounds = () => {
  const dispatch = useDispatch();
  const autoRefresh = useSelector(selectAutoRefresh);
  const items = useSelector(selectItems);
  const status = useSelector(selectStatus);

  useEffect(() => {
    dispatch(getData());

    return () => {
      dispatch(stopInterval(ROUNDS));
    };
  }, [dispatch]);

  useEffect(() => {
    if (autoRefresh === 'false') {
      dispatch(stopInterval(ROUNDS));
    }
  }, [autoRefresh, dispatch]);

  return <Rounds status={status} items={items} />;
};

export default WrappedRounds;
