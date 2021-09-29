import React from 'react';
import PropTypes from 'prop-types';
import { useDrag, useDrop } from 'react-dnd';
import { CALENDAR_EVENT } from './CalendarConstants';

const Event = (props) => {
  const { move, label } = props;
  
  const [, drag] = useDrag({
    type: CALENDAR_EVENT,
    item: {
      ...props,
      type: CALENDAR_EVENT,
    },
    end: (item, monitor) => {
      const dropResult = monitor.getDropResult();

      if (dropResult) {
        const { newDate } = dropResult;

        move(item, newDate);
      }
    },
  });

  return (
    <div ref={drag} className='event'>
      {label}
    </div>
  );
};

Event.propTypes = {
  move: PropTypes.func.required,
  label: PropTypes.object.required,
};

export default Event;
