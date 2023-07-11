import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { DndProvider } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';
import './Calendar.scss';

import { views, getView } from './View';

const Calendar = (props) => {
  const { start, end, weekStartsOn, locale, onEventMoved } = props;

  const initialDate = () => {
    const { date } = props;
    if (date < start || date > end) {
      return (date < start) ? new Date(start) : new Date(end);
    } else {
      return date;
    }
  };

  const [date, setDate] = useState(initialDate());
  const [view, setView] = useState(props.view);
  const [events, setEvents] = useState(props.events);

  const movedCallback = (updatedEvent) => {
    onEventMoved(updatedEvent);

    const result = events.map(event => {
      if (event.id === updatedEvent.id) {
        return { ...event, ...updatedEvent };
      }
      return event;
    });

    setEvents(result);
  };

  let View = getView(view);

  return (
    <div className="calendar">
      <DndProvider backend={HTML5Backend}>
        <View
          start={start}
          end={end}
          date={date}
          setDate={setDate}
          setView={view}
          events={events}
          onEventMoved={movedCallback}
          locale={locale}
          weekStartsOn={weekStartsOn}
        />
      </DndProvider>
    </div>
  );
};

Calendar.propTypes = {
  start: PropTypes.instanceOf(Date),
  end: PropTypes.instanceOf(Date),
  date: PropTypes.instanceOf(Date),
  view: PropTypes.oneOf(Object.values(views)),
  events: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    start: PropTypes.instanceOf(Date).isRequired,
    end: PropTypes.instanceOf(Date).isRequired,
    title: PropTypes.node.isRequired,
  })),
  onEventMoved: PropTypes.func,
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
};

Calendar.defaultProps = {
  start: null,
  end: null,
  date: new Date(),
  view: views.MONTH,
  events: [],
  onEventMoved: (event) => { },
  locale: 'en-US',
  weekStartsOn: 1,
};

export default Calendar;
