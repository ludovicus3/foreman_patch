import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import PropTypes from 'prop-types';

import { stopInterval } from 'foremanReact/redux/middlewares/IntervalMiddleware';

import {
  selectProgress,
  selectAutoRefresh,
  selectStatus,
} from './RoundProgressSelectors';
import { getProgress } from './RoundProgressActions';
import { ROUND_PROGRESS } from './RoundProgressConstants';
import RoundProgress from './RoundProgress';

const WrappedRoundProgress = ({ round }) => {
  const dispatch = useDispatch();

  const progress = useSelector(selectProgress);
  const autoRefresh = useSelector(selectAutoRefresh);
  const status = useSelector(selectStatus);

  useEffect(() => {
    dispatch(getProgress(round));

    if (!autoRefresh) {
      dispatch(stopInterval(ROUND_PROGRESS));
    }

    return () => {
      dispatch(stopInterval(ROUND_PROGRESS));
    };
  }, [dispatch, autoRefresh]);

  return (
    <RoundProgress progress={progress} />
  );
};

WrappedRoundProgress.propTypes = {
  round: PropTypes.number.isRequired,
};

export default WrappedRoundProgress;
