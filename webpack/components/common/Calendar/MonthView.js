import React from 'react';
import PropTypes from 'prop-types';
import Day from './Day';
import { chunk, times } from 'lodash';
import {
  addDays,
  addMonths,
  isPastDate,
  isFutureDate,
  getMonthStart,
  getWeekArray,
} from './CalendarHelpers';

class MonthView extends React.Component {
  get weeks() {
    const { date, weekStartsOn } = this.props;
    const monthStart = getMonthStart(new Date(date));
    const offset = monthStart.getDay() - weekStartsOn;
    return chunk(times(35, i => addDays(monthStart, i - offset)), 7);
  }

  render() {
    const { first, last, date, locale, weekStartsOn, events } = this.props;

    const daysOfTheWeek = getWeekArray(weekStartsOn, locale);

    return (
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
          {this.weeks.map((week) => (
            <tr className="week">
              {week.map((day) => (
                <Day
                  key={day}
                  date={day}
                  enabled={!isPastDate(day, first) && !isFutureDate(day, last)}
                  events={events}
                />
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    );
  }
}

MonthView.propTypes = {
  first: PropTypes.instanceOf(Date),
  last: PropTypes.instanceOf(Date),
  date: PropTypes.instanceOf(Date),
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
  events: PropTypes.array,
};

MonthView.defaultProps = {
  first: null,
  last: null,
  date: new Date(),
  locale: 'en-US',
  weekStartsOn: 1,
  events: [],
};

export default MonthView;
