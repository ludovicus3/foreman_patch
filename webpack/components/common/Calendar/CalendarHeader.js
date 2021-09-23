import React from 'react';
import PropTypes from 'prop-types';
import { Icon, Button } from 'patternfly-react';
import { addDays, addMonths } from './CalendarHelpers';
import { DAY, WEEK, MONTH } from './CalendarConstants';

const CalendarHeader = (props) => {
  const { range, date, view, setDate, locale } = props;

  const updateDate = (change) => {
    switch (view) {
      case DAY:
        setDate(addDays(date, change));
        break;
      case WEEK:
        setDate(addDays(date, change * 7));
        break;
      case MONTH:
      default:
        setDate(addMonths(date, change));
        break;
    }
  };

  const hasPreviousView = () => {
    switch (view) {
      case DAY:
        return date <= range.end;
      case WEEK:
      case MONTH:
      default:
        return date.getMonth() <= range.end.getMonth();
    }
  };

  const hasNextView = () => {
    switch (view) {
      case DAY:
        return date >= range.end;
      case WEEK:
      case MONTH:
      default:
        return date.getMonth() >= range.end.getMonth();
    }
  };

  const month = Intl.DateTimeFormat(locale, { month: 'long' }).format(date);
  const year = date.getFullYear();

  return (
    <div className="header">
      <Button variant="secondary" onClick={() => updateDate(-1)} isDisabled={hasPreviousView() ? false : true}>
        <Icon type="fa" name="angle-left" />
      </Button>
      <div className="col-md-5">
        {month} {year}
      </div>
      <Button variant="secondary" onClick={() => updateDate(1)} isDisabled={hasNextView() ? false : true}>
        <Icon type="fa" name="angle-right" />
      </Button>
    </div>
  );
};

CalendarHeader.propTypes = {
  range: PropTypes.shape({
    start: PropTypes.instanceOf(Date),
    end: PropTypes.instanceOf(Date),
  }),
  date: PropTypes.instanceOf(Date),
  view: PropTypes.oneOf([DAY, WEEK, MONTH]),
  setDate: PropTypes.func,
  locale: PropTypes.string,
};

CalendarHeader.defaultProps = {
  range: {
    start: null,
    end: null,
  },
  date: new Date(),
  view: MONTH,
  setDate: null,
  locale: 'en-US',
};

export default CalendarHeader;
