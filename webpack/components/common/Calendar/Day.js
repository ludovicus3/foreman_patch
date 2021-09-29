import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { useDrop } from 'react-dnd';
import classNames from 'classnames';
import { 
  isEqualDate,
  isPastDate,
  isFutureDate,
} from './CalendarHelpers';
import Event from './Event';
import { CALENDAR_EVENT } from './CalendarConstants';

const Day = (props) => {
  const { date, enabled } = props;

  const events = props.events.filter(event => isEqualDate(date, event.start));

  const adjustDate = (oldDate, newDate) => {
    const result = new Date(oldDate);
    oldDate.setFullYear(newDate.getFullYear());
    oldDate.setMonth(newDate.getMonth());
    oldDate.setDate(newDate.getDate());
    return result;
  };

  const [{isOver, canDrop}, drop] = useDrop({
    accept: CALENDAR_EVENT,
    drop: (item) => ({ newDate: adjustDate(item.start, date) }),
    collect: (monitor) => ({
      isOver: monitor.isOver(),
      canDrop: monitor.canDrop(),
    }),
    canDrop: () => {
      return enabled;
    },
  });

  const classes = {
    disabled: !enabled,
    enabled: enabled,
    today: isEqualDate(date, new Date()),
    past: isPastDate(date),
    future: isFutureDate(date),
  }

  return (
    <td className={classNames(`day wday-${date.getDay()}`, classes)} data-day={date.getDate()}>
      <h6>{date.getDate()}</h6>
      <div ref={drop} className="day">
        {events.map((event) => (
          <Event {...event} />
        ))}
      </div>
    </td>
  );
};

Day.propTypes = {
  date: PropTypes.instanceOf(Date).isRequired,
  enabled: PropTypes.bool,
  events: PropTypes.array,
};

Day.defaultProps = {
  enabled: false,
  events: [],
};

export default Day;
