import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { useSelector, useDispatch } from 'react-redux';

import PlanWindow from './PlanWindow';
import {
  selectPlanWindow,
  selectStatus,
} from './PlanWindowSelectors';
import {
  getPlanWindow,
  moveGroup,
} from './PlanWindowActions';

const WrappedPlanWindow = ({ id }) => {
  const dispatch = useDispatch();

  const planWindow = useSelector(selectPlanWindow);
  const status = useSelector(selectStatus);

  useEffect(() => {
    dispatch(getPlanWindow(id));
  }, [dispatch]);

  return (<PlanWindow {...planWindow} status={status} />);
};

WrappedPlanWindow.propTypes = {
  id: PropTypes.number.isRequired,
};

export default WrappedPlanWindow;
