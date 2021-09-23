import React from 'react';
import PropTypes from 'prop-types';
import { Icon } from 'patternfly-react';
import { getWeekArray } from './CalendarHelpers.js';

const WeekHeader = ({
  getPreviousView,
  getNextView,
  zoomOut,
  title,
  locale,
  weekStartsOn,
}) => {
  const daysOfTheWeek = getWeekArray(weekStartsOn, locale);

  return (
    <thead>
      <tr>
        {daysOfTheWeek.map((day, idx) => (
          <th key={idx} className="dow">
            {day}
          </th>
        ))}
      </tr>
    </thead>
  );
};

WeekHeader.propTypes = {
  getPreviousView: PropTypes.func,
  getNextView: PropTypes.func,
  zoomOut: PropTypes.func,
  title: PropTypes.string,
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
};

WeekHeader.defaultProps = {
  getPreviousView: null,
  getNextView: null,
  zoomOut: null,
  title: '',
  locale: 'en-US',
  weekStartsOn: 1,
};

export default WeekHeader;
