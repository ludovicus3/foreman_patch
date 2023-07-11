import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import Invocation from './Invocation';
import {
  selectInvocation,
  selectState,
  selectStatus,
} from './InvocationSelectors';
import { getData } from './InvocationActions';
import { INVOCATION } from './InvocationsConsts';

const WrappedInvocation = () => {
  const dispatch = useDispatch();
  const state = useSelector(selectState);
  const invocation = useSelector(selectInvocation);
  const status = useSelector(selectStatus);
  
  useEffect(() => {
    dispatch(getData());

    return () => {
      dispatch(stopInterval(INVOCATION));
    };
  }, [dispatch]);

  useEffect(() => {
    if (state === 'stopped') {
      dispatch(stopInterval(INVOCATION));
    }
  }, [state, dispatch]);

  return <Invocation invocation={invocation} status={status}/>
};

export default WrappedInvocation;
