import React, { useState, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { Grid, Button, Icon } from 'patternfly-react';

import {
  addMonths,
  startOfMonth,
  endOfMonth,
} from '../CalendarHelpers';
import { CALENDAR_EVENT } from '../CalendarConstants';

const Header = ({ start, end, date, setDate, setView, locale, weekStartsOn }) => {
  const formatter = Intl.DateTimeFormat(locale, { month: 'long', year: 'numeric' })

  const previousDate = addMonths(date, -1);
  const previousDisabled = startOfMonth(date) < start;
  const nextDate = addMonths(date, 1);
  const nextDisabled = endOfMonth(date) > end;

  const [wait, setWait] = useState(false);

  useEffect(() => {
    if (wait) {
      setTimeout(() => {
        setWait(false);
      }, 1000);
    }
  }, [wait]);

  const gotoPreviousMonth = () => {
    setDate(previousDate);
  };

  const gotoNextMonth = () => {
    setDate(nextDate);
  };

  const [, previous] = useDrop({
    accept: CALENDAR_EVENT,
    hover: (item, monitor) => {
      if (!wait) {
        gotoPreviousMonth();
        setWait(true);
      }
    },
  });

  const [, next] = useDrop({
    accept: CALENDAR_EVENT,
    hover: (item, monitor) => {
      if (!wait) {
        gotoNextMonth();
        setWait(true);
      }
    },
  });

  return (
    <div className="calendar-header">
      <span className="previous col-md-2" ref={previous}>
        <Button variant="secondary" onClick={gotoPreviousMonth} disabled={previousDisabled} size="lg">
          <Icon type="fa" name="angle-left" /> {formatter.format(previousDate)}
        </Button>
      </span>
      <span className="calendar-title col-md-8">
        {formatter.format(date)}
      </span>
      <span className="next col-md-2" ref={next}>
        <Button variant="secondary" onClick={gotoNextMonth} disabled={nextDisabled} size="lg">
          {formatter.format(nextDate)} <Icon type="fa" name="angle-right" />
        </Button>
      </span>
    </div>
  );
};

export default Header;
