import React from 'react';
import PropTypes from 'prop-types';
import { Icon, Button } from 'patternfly-react';
import { addDays, addMonths } from './CalendarHelpers';
import { DAY, WEEK, MONTH } from './CalendarConstants';

class CalendarHeader extends React.Component {
  jumpToPreviousView = () => {
    const { date, view, setDate } = this.props;

    switch (view) {
      case DAY:
        setDate(addDays(date, -1));
        break;
      case WEEK:
        setDate(addDays(date, -7));
        break;
      case MONTH:
      default:
        setDate(addMonths(date, -1));
    }
  }

  jumpToNextView = () => {
    const { date, view, setDate } = this.props;

    switch (view) {
      case DAY:
        setDate(addDays(date, 1));
        break;
      case WEEK:
        setDate(addDays(date, 7));
        break;
      case MONTH:
      default:
        setDate(addMonths(date, 1));
    }
  }

  get title() {
    const { locale, date } = this.props;

    const month = Intl.DateTimeFormat(locale, { month: 'long' }).format(date);
    const year = date.getFullYear();

    return (<h4>{month} {year}</h4>);
  }

  render() {
    return (
      <div className="header">
        <Button variant="secondary" onClick={this.jumpToPreviousView} >
          <Icon type="fa" name="angle-left" />
        </Button>
        <div className="col-md-5">
          {this.title}
        </div>
        <Button variant="secondary" onClick={this.jumpToNextView} >
          <Icon type="fa" name="angle-right" />
        </Button>
      </div>
    );
  }
}

CalendarHeader.propTypes = {
  first: PropTypes.instanceOf(Date),
  last: PropTypes.instanceOf(Date),
  date: PropTypes.instanceOf(Date),
  view: PropTypes.oneOf([DAY, WEEK, MONTH]),
  setDate: PropTypes.func,
  setView: PropTypes.func,
  locale: PropTypes.string,
};

CalendarHeader.defaultProps = {
  first: null,
  last: null,
  date: new Date(),
  view: MONTH,
  setDate: null,
  setView: null,
  locale: 'en-US',
};

export default CalendarHeader;
