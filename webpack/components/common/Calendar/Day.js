import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { isEqualDate } from './CalendarHelpers';

const Day = (props) => {
  const { day, onDateClicked, classNamesArray, events } = props;
  const date = day.getDate();

  return (
    <td
      className={classNames('day', classNamesArray)}
      data-day={date}
      onClick={() => {
        onDateClicked(day);
      }}
    >
      <h6>{date}</h6>
      <div className="day">
        {events.filter(e => isEqualDate(day, new Date(e.date))).map(e => e.event)}
      </div>
    </td>
  );
};

Day.propTypes = {
  day: PropTypes.instanceOf(Date).isRequired,
  onDateClicked: PropTypes.func,
  classNamesArray: PropTypes.object,
  events: PropTypes.array,
};

Day.defaultProps = {
  onDateClicked: null,
  classNamesArray: [],
  events: [],
};

export default Day;
