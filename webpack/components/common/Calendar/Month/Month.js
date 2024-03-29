import React from 'react';
import { Grid } from 'patternfly-react';

import Day from './Day';
import Header from './Header';
import {
  getWeeksOfMonth,
  getWeekArray,
  isEqualDate,
} from '../CalendarHelpers';

const Month = ({start, end, date, setDate, setView, events, onEventMoved, locale, weekStartsOn}) => {
  const weeks = getWeeksOfMonth(date, weekStartsOn); 
  const daysOfTheWeek = getWeekArray(weekStartsOn, locale);

  const isDayEnabled = (date) => {
    return (start <= date && end > date);
  };

  return (
    <div>
      <Header start={start} end={end} date={date} setDate={setDate} setView={setView} locale={locale} weekStartsOn={weekStartsOn}/>
      <table className="calendar-view table table-bordered table-fixed">
        <thead>
          <tr>
            {daysOfTheWeek.map((day, index) => (
              <th key={index} className="dow">
                {day}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {weeks.map(week => (
            <tr className="week">
              {week.map(day => (
                <Day key={day} date={day} enabled={isDayEnabled(day)} events={events} onEventMoved={onEventMoved} />
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Month;
