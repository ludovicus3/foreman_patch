import React from 'react';
import PropTypes from 'prop-types';
import { useDrag, useDrop } from 'react-dnd';
import { CALENDAR_EVENT } from './CalendarConstants';

const Event = (props) => {
  const { title } = props;

  const [, drag] = useDrag({
    type: CALENDAR_EVENT,
    item: {
      type: CALENDAR_EVENT,
      ...props,
    },
  });

  return (
    <div ref={drag} className='event'>
      {title}
    </div>
  );
};

Event.propTypes = {
  start: PropTypes.instanceOf(Date).isRequired,
  end: PropTypes.instanceOf(Date).isRequired,
  title: PropTypes.node.isRequired,
  onMoved: PropTypes.func,
};

Event.defaultProps = {
  onMoved: null,
};

export default Event;
