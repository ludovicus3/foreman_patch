import React from 'react';
import PropTypes from 'prop-types';

import WeekHeader from './WeekHeader';
import Day from './Day';
import { chunk, times } from 'lodash';

import {
  addDays,
  addMonths,
  isPast,
  isFuture,
  getMonthStart,
} from './CalendarHelpers';


class MonthView extends React.Component {
  state = {
  };
  static getDerivedStateFromProps(props, state) {
    if (props.date !== state.date) {
      return {
        date: props.date,
      };
    }
    return null;
  }

  calendarArray = (date) => {
    const { weekStartsOn } = this.props;
    const monthStart = getMonthStart(new Date(date));
    const offset = monthStart.getDay() - weekStartsOn;
    return chunk(times(35, i => addDays(monthStart, i - offset)), 7);
  }

  hasPreviousView = () => {
    const { range } = this.props;
    const { date } = this.state;

    return range.start.getMonth() < date.getMonth();
  }

  hasNextView = () => {
    const { range } = this.props;
    const { date } = this.state;

    return range.end.getMonth() > date.getMonth();
  }

  getPreviousView = () => {
    if (!this.hasPreviousView()) return;

    const { date } = this.state;
    this.setState({ date: addMonths(date, -1) });
  }

  getNextView = () => {
    if (!this.hasNextView()) return;

    const { date } = this.state;
    this.setState({ date: addMonths(date, 1) });
  }

  getDayClassNamesArray = (day) => {
    const { range } = this.props;
    
    var array = [];
    array.push("wday-" + day.getDay());
    
    if (range.start <= day && range.end >= day) {
      array.push("enabled");
    } else {
      array.push("disabled");
    }

    if (isPast(day)) {
      array.push("past");
    } else if (isFuture(day)) {
      array.push("future");
    } else {
      array.push("today");
    }

    return array;
  }

  title = () => {
    const { locale } = this.props;
    const { date } = this.state;

    const month = Intl.DateTimeFormat(locale, {month: 'long'}).format(date);
    const year = date.getFullYear();
    return month.toString() + " " + year.toString();
  }

  render() {
    const { locale, weekStartsOn, changeView, onDateClicked, events } = this.props;
    const { date } = this.state;

    const calendar = this.calendarArray(date);
    return (
      <table className="table table-bordered table-fixed">
        <WeekHeader
          getPreviousView={this.getPreviousView}
          getNextView={this.getNextView}
          title={this.title()}
          locale={locale}
          weekStartsOn={weekStartsOn}
        />
        <tbody>
          {calendar.map((week, idx) => (
            <tr className="week">
              {week.map((day) => (
                <Day
                  key={day}
                  day={day}
                  onDateClicked={onDateClicked}
                  classNamesArray={this.getDayClassNamesArray(day)}
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
  range: PropTypes.shape({
    start: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
    end: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  }),
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
  changeView: PropTypes.func,
  changeDate: PropTypes.func,
  onDateClicked: PropTypes.func,
  date: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  events: PropTypes.array,
};

MonthView.defaultProps = {
  range: {
    start: null,
    end: null,
  },
  locale: 'en-US',
  weekStartsOn: 1,
  changeView: null,
  changeDate: null,
  onDateClicked: null,
  date: new Date(),
  events: [],
};

export default MonthView;
