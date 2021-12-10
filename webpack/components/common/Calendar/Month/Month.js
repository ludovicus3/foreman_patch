import React from 'react';

import Day from './Day';
import Header from './Header';
import {
  getWeeksOfMonth,
  getWeekArray,
  isEqualDate,
} from '../CalendarHelpers';

const Month = ({start, end, date, setDate, setView, events, locale, weekStartsOn}) => {
  const weeks = getWeeksOfMonth(date, weekStartsOn); 
  const daysOfTheWeek = getWeekArray(weekStartsOn, locale);

  const isDayEnabled = (date) => {
    return (start <= date && end > date);
  };

  return (
    <div className="month">
      <Header start={start} end={end} date={date} setDate={setDate} setView={setView} locale={locale} weekStartsOn={weekStartsOn}/>
      <div className="month-body">
        <table className="table table-bordered table-fixed">
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
                  <Day key={day} date={day} enabled={isDayEnabled(day)} events={events}/>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Month;
