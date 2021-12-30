import React, { useState } from 'react';
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
  const { date, enabled, onEventMoved } = props;

  const events = props.events.filter(event => isEqualDate(date, event.start));

  const [{ canDrop, isOver }, drop] = useDrop({
    accept: CALENDAR_EVENT,
    drop: (event, monitor) => {
      const start = new Date(event.start);
      const end = new Date(event.end);

      let delta = Math.ceil((date - start) / (1000 * 60 * 60 * 24));

      start.setDate(start.getDate() + delta);
      end.setDate(end.getDate() + delta);

      onEventMoved({...event, start, end});
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
        {events.map((event) => (<Event {...event} />))}
      </div>
    </td>
  );
};

export default Day;
