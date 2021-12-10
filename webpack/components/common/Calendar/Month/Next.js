import React, { useState, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { Button, Icon } from 'patternfly-react';

import {
  addMonths,
  endOfMonth,
} from '../CalendarHelpers';
import { CALENDAR_EVENT } from '../CalendarConstants';

const Next = ({ bound, date, setDate, locale }) => {
  const month = Intl.DateTimeFormat(locale, { month: 'long' }).format(addMonths(date, 1));

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
    if (bound > endOfMonth(date)) {
      setDate(addMonths(date, 1));
    }
  };

  return (
    <span ref={drop} >
      <Button variant="secondary" onClick={onClick} >
        {month} <Icon type="fa" name="angle-right" />
      </Button>
    </span>
  );
};

export default Next;
