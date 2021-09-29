import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { DndProvider } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';
import DayView from './DayView';
import WeekView from './WeekView';
import MonthView from './MonthView';
import CalendarHeader from './CalendarHeader';
import { DAY, WEEK, MONTH } from './CalendarConstants';

class Calendar extends React.Component {
  constructor(props) {
    super(props);

    this.props.first = this.initializeDate(this.props.first);
    this.props.last = this.initializeDate(this.props.last);
    this.props.date = this.initializeDate(this.props.date, new Date());

    if (this.props.first > this.props.date || this.props.last < this.props.date) {
      this.props.date = new Date(this.props.first);
    }

    this.state = {
      date: this.props.date,
      view: this.props.view,
      events: this.props.events,
    };
  }

  initializeDate(date, fallback = null) {
    return !!Date.parse(date) ? new Date(date) : fallback;
  }

  setDate = (date) => {
    this.setState({
      date: this.initializeDate(date, this.state.date),
    });
  }

  setView = (view) => {
    this.setState({
      view: view,
    });
  }

  renderView() {
    const props = {
      ...this.props,
      ...this.state,
    };

    const { view } = this.state;

    switch (view) {
      case DAY:
        return (<DayView {...props} />);
      case WEEK:
        return (<WeekView {...props} />);
      case MONTH:
      default:
        return (<MonthView {...props} />);
    }
  }

  render() {
    const props = {
      ...this.props,
      ...this.state,
    };

    return (
      <div className="calendar">
        <CalendarHeader {...props} setDate={this.setDate} setView={this.setView} />
        <DndProvider backend={HTML5Backend}>
          {this.renderView()}
        </DndProvider>
      </div>
    );
  }
}

Calendar.propTypes = {
  first: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  last: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  date: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
  view: PropTypes.oneOf([DAY, WEEK, MONTH]),
  events: PropTypes.arrayOf(PropTypes.object),
  locale: PropTypes.string,
  weekStartsOn: PropTypes.number,
};

Calendar.defaultProps = {
  first: null,
  last: null,
  date: new Date(),
  view: MONTH,
  events: [],
  locale: 'en-US',
  weekStartsOn: 1,
};

export default Calendar;
