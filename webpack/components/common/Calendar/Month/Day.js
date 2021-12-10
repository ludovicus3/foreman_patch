import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { useDrop } from 'react-dnd';
import classNames from 'classnames';
import { 
  isEqualDate,
  startOfDay,
  endOfDay,
} from '../CalendarHelpers';
import Event from '../Event';
import { CALENDAR_EVENT } from '../CalendarConstants';

const Day = (props) => {
  const { date, enabled } = props;

  const events = props.events.filter(event => isEqualDate(date, event.start));

  const [, drop] = useDrop({
    accept: CALENDAR_EVENT,
    drop: (item, monitor) => {
      const { onMoved } = item;

      let delta = Math.ceil((date - item.start) / (1000 * 60 * 60 * 24));

      item.start.setDate(item.start.getDate() + delta);
      item.end.setDate(item.end.getDate() + delta);

      if (onMoved) {
        onMoved(item);
      }
    },
    canDrop: (item, monitor) => (enabled),
  });

  const classes = {
    disabled: !enabled,
    enabled: enabled,
    today: isEqualDate(date, new Date()),
    past: date < startOfDay(),
    future: date > endOfDay(),
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
