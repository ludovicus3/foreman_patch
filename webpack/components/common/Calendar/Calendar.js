import React, { useState } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import DayView from './DayView';
import WeekView from './WeekView';
import MonthView from './MonthView';
import CalendarHeader from './CalendarHeader';
import { DAY, WEEK, MONTH } from './CalendarConstants';

const Calendar = (props) => {
  const [date, setDate] = useState(new Date(props.date));
  const [view, setView] = useState(props.view);

  const range = {
    start: new Date(props.range.start),
    end: new Date(props.range.end),
  };

  const { locale, onDateClicked, weekStartsOn, className, events } = props;

  const getCalendarView = () => {
    switch (view) {
      case DAY:
        return (
          <DayView
            range={range}
            locale={locale}
            changeView={setView}
            changeDate={setDate}
            onDateClicked={onDateClicked}
            date={date}
          />
        );
      case WEEK:
        return (
          <WeekView
            range={range}
            locale={locale}
            weekStartsOn={weekStartsOn}
            changeView={setView}
            changeDate={setDate}
            onDateClicked={onDateClicked}
            date={date}
          />
        );
      case MONTH:
      default:
        return (
          <MonthView
            range={range}
            locale={locale}
            weekStartsOn={weekStartsOn}
            setView={setView}
            setDate={setDate}
            onDateClicked={onDateClicked}
            date={date}
            events={events}
          />
        );
    }
  };

  return (
    <div className={classNames('calendar', className)}>
      <CalendarHeader
        range={range}
        date={date}
        view={view}
        setDate={setDate}
        setView={setView}
        locale={locale}
      />
      {getCalendarView()}
    </div>
  );
};

Calendar.propTypes = {
  range: PropTypes.shape({
    start: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
    end: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  }),
  onDateClicked: PropTypes.func,
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
  className: PropTypes.string,
  view: PropTypes.oneOf([DAY, WEEK, MONTH]),
  date: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  events: PropTypes.arrayOf(
    PropTypes.shape({
      date: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
      event: PropTypes.object,
    })
  ),
};

Calendar.defaultProps = {
  range: {
    start: null,
    end: null,
  },
  onDateClicked: null,
  locale: 'en-US',
  weekStartsOn: 1,
  className: '',
  view: MONTH,
  date: new Date(),
  events: [],
};

export default Calendar;
