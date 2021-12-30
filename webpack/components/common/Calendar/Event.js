import React from 'react';
import PropTypes from 'prop-types';
import { useDrag, useDrop } from 'react-dnd';
import { CALENDAR_EVENT } from './CalendarConstants';

const Event = (props) => {

  const [, drag] = useDrag({
    type: CALENDAR_EVENT,
    item: {
      type: CALENDAR_EVENT,
      ...props,
    },
  });

  const { title } = props;

  return (
    <div ref={drag} className='event'>
      {title}
    </div>
  );
};

export default Event;
