import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { DndProvider } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';
import './Calendar.scss';

import { views, getView } from './View';

const Calendar = (props) => {
  const {start, end, weekStartsOn, locale} = props;

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

  let View = getView(view);

  return (
    <div className="calendar">
      <DndProvider backend={HTML5Backend}>
        <View start={start} end={end} date={date} setDate={setDate} setView={view} events={events} locale={locale} weekStartsOn={weekStartsOn}/>
      </DndProvider>
    </div>
  );
};

Calendar.propTypes = {
  start: PropTypes.instanceOf(Date),
  end: PropTypes.instanceOf(Date),
  date: PropTypes.instanceOf(Date),
  view: PropTypes.oneOf(Object.values(views)),
  events: PropTypes.array,
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
};

Calendar.defaultProps = {
  start: null,
  end: null,
  date: new Date(),
  view: views.MONTH,
  events: [],
  locale: 'en-US',
  weekStartsOn: 1,
};

export default Calendar;
