import React, { useState, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { Button, Icon } from 'patternfly-react';

import {
  addMonths,
  startOfMonth,
} from '../CalendarHelpers';
import { CALENDAR_EVENT } from '../CalendarConstants';

const Previous = ({ bound, date, setDate, locale }) => {
  const month = Intl.DateTimeFormat(locale, { month: 'long' }).format(addMonths(date, -1));

  const [wait, setWait] = useState(false);

  useEffect(() => {
    if (wait) {
      setTimeout(() => {
        setWait(false);
      }, 1000);
    }
  }, [wait]);

  const [, drop] = useDrop({
    accept: CALENDAR_EVENT,
    hover: (item, monitor) => {
      if (!wait) {
        onClick();
        setWait(true);
      }
    },
  });

  const onClick = () => {
    if (bound < startOfMonth(date)) {
      setDate(addMonths(date, -1));
    }
  };

  return (
    <span ref={drop} >
      <Button variant="secondary" onClick={onClick} >
        <Icon type="fa" name="angle-left" /> {month}
      </Button>
    </span>
  );
};

export default Previous;
