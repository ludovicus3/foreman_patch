import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { useSelector, useDispatch } from 'react-redux';

import Cycle from './Cycle';
import {
  selectCycle,
  selectStatus,
} from './CycleSelectors';
import {
  getCycle,
  moveWindow,
} from './CycleActions';
import { CYCLE } from './CycleConstants';

const WrappedCycle = ({ id }) => {
  const dispatch = useDispatch();

  const cycle = useSelector(selectCycle);
  const status = useSelector(selectStatus);

  const updateWindow = (window) => {
    dispatch(moveWindow(window));
  };

  useEffect(() => {
    dispatch(getCycle(id));
  }, [dispatch]);

  return (<Cycle {...cycle} moveWindow={updateWindow} status={status} />);
};

WrappedCycle.propTypes = {
  id: PropTypes.number.isRequired,
  locale: PropTypes.string,
};

WrappedCycle.defaultProps = {
  locale: 'en-US',
};

export default WrappedCycle;
