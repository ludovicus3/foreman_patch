import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { useSelector, useDispatch } from 'react-redux';

import Plan from './Plan';
import {
  selectPlan,
  selectStatus,
} from './PlanSelectors';
import {
  getPlan,
  moveWindow,
} from './PlanActions';
import { PLAN } from './PlanConstants';

const WrappedPlan = ({ id }) => {
  const dispatch = useDispatch();

  const plan = useSelector(selectPlan);
  const status = useSelector(selectStatus);

  const updateWindow = (window) => {
    dispatch(moveWindow(window));
  };

  useEffect(() => {
    dispatch(getPlan(id));
  }, [dispatch]);

  return (<Plan {...plan} moveWindow={updateWindow} status={status} />);
};

WrappedPlan.propTypes = {
  id: PropTypes.number.isRequired,
};

export default WrappedPlan;
