import React from 'react';
import PropTypes from 'prop-types';
import Window from './Window';
import Calendar from '../common/Calendar/Calendar';
import Event from '../common/Calendar/Calendar';

const Plan = ({
  id,
  name,
  description,
  start,
  end,
  interval,
  units,
  correction,
  activeCount,
  windows,
}) => {
  const moveWindow = (window, date) => {
    const duration = window.end - window.start
    window.start = new Date(date);
    window.end = new Date(window.start.getTime() + duration);
    console.log(window);
  };

  const events = windows.map((window) => ({
    ...window,
    start: new Date(window.start),
    end: new Date(window.end),
    move: moveWindow,
    label: (<Window {...window} />),
  }));
  
  return <Calendar first={start} last={end} events={events} />;
};

Plan.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  start: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]).isRequired,
  end: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]).isRequired,
  interval: PropTypes.number.isRequired,
  units: PropTypes.oneOf(['days', 'weeks', 'months']),
  correction: PropTypes.string,
  activeCount: PropTypes.number.isRequired,
  windows: PropTypes.array, 
};

Plan.defaultProps = {
  description: null,
  correction: null,
  windows: [],
};

export default Plan;
