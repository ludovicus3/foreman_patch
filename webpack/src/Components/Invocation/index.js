import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { useSelector, useDispatch } from 'react-redux';
import { Alert } from '@patternfly/react-core';
import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';
import Invocation from './Invocation';
import {
  selectInvocation,
  selectStatus,
} from './InvocationSelectors';
import { getData } from './InvocationActions';
import { INVOCATION } from './InvocationConsts';
import Loading from '../Loading';

const WrappedInvocation = ({ id }) => {
  const dispatch = useDispatch();
  const invocation = useSelector(selectInvocation);
  const loadingStatus = useSelector(selectStatus);

  const isCompleted = () => {
    const status = invocation.status;
    return (status === 'error' || status === 'warning' || status === 'success' || status === 'cancelled');
  };

  useEffect(() => {
    dispatch(getData(id));

    return () => {
      dispatch(stopInterval(INVOCATION));
    };
  }, [dispatch]);

  useEffect(() => {
    if (isCompleted()) {
      dispatch(stopInterval(INVOCATION));
    }
  }, [state, dispatch]);

  if (loadingStatus === STATUS.PENDING) {
    return <Loading />;
  }

  if (loadingStatus === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error while updating the status, try refreshing the page.'
        )}
      </Alert>
    );
  }

  return (
    <Invocation {...invocation} />
  );
};

WrappedInvocation.propTypes = {
  id: PropTypes.number.isRequired
};

export default WrappedInvocation;
