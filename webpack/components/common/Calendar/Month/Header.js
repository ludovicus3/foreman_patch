import React from 'react';
import { Row, Button, Icon } from 'patternfly-react';

import {
  addMonths,
  startOfMonth,
  endOfMonth,
} from '../CalendarHelpers';
import Previous from './Previous';
import Next from './Next';

const Header = ({ start, end, date, setDate, setView, locale, weekStartsOn }) => {
  const month = Intl.DateTimeFormat(locale, { month: 'long' }).format(date);
  const year = date.getFullYear();

  const canGotoPreviousMonth = () => {
    return start < startOfMonth(date);
  };

  const canGotoNextMonth = () => {
    return end > endOfMonth(date);
  };

  const gotoPreviousMonth = () => {
    setDate(addMonths(date, -1));
  };

  const gotoNextMonth = () => {
    setDate(addMonths(date, 1));
  };

  return (
    <div className="month-header">
      <Previous bound={start} date={date} setDate={setDate} locale={locale} />
      <span>{month} {year}</span>
      <Next bound={end} date={date} setDate={setDate} locale={locale} />
    </div>
  );
};

export default Header;
