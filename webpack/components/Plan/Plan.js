import React from 'react';
import PropTypes from 'prop-types';
import { LoadingState, Alert } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import { STATUS } from 'foremanReact/constants';

import Window from './Window';
import Calendar from '../common/Calendar';

const Plan = ({
  id,
  name,
  description,
  start_date,
  end_date,
  interval,
  units,
  correction,
  activeCount,
  window_plans,
  moveWindow,
  status,
}) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There is an error while loading the cycle, try refreshing the page.'
        )}
      </Alert>
    );
  }

  const start = new Date(start_date + 'T00:00:00.000');
  const end = new Date(end_date + 'T23:59:59.999');

  const onEventMoved = (event) => {
    const window = {
      id: event.id,
      start_day: Math.floor((event.start.getTime() - start.getTime()) / (24 * 60 * 60 * 1000)),
      duration: (event.end.getTime() - event.start.getTime()) / 1000,
      start_time: event.start,
    };

    moveWindow(window);
  };


  const events = window_plans.map(window => {
    const start = new Date(window.start_time);
    const end = new Date(start.getTime() + window.duration * 1000);

    return {
      id: window.id,
      start: start,
      end: end,
      title: <Window {...window} />
    };
  });

  return (
    <LoadingState loading={status === STATUS.PENDING} >
      <Calendar start={start} end={end} events={events} onEventMoved={onEventMoved} />
    </LoadingState>
  );
};

Plan.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  start_date: PropTypes.string.isRequired,
  end_date: PropTypes.string.isRequired,
  interval: PropTypes.number.isRequired,
  units: PropTypes.oneOf(['days', 'weeks', 'months']).isRequired,
  correction: PropTypes.string,
  activeCount: PropTypes.number.isRequired,
  window_plans: PropTypes.array,
  moveWindow: PropTypes.func,
  status: PropTypes.string.isRequired,
};

Plan.defaultProps = {
  description: null,
  correction: null,
  window_plans: [],
  moveWindow: (window) => {},
};

export default Plan;
