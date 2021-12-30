import React from 'react';
import PropTypes from 'prop-types';
import { LoadingState, Alert } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import { STATUS } from 'foremanReact/constants';

import Calendar from '../common/Calendar';
import Window from './Window';

const Cycle = ({ id, name, description, start_date, end_date, windows, moveWindow, status}) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error while loading the cycle, try refreshing the page.'
        )}
      </Alert>
    );
  }

  const start = new Date(start_date + 'T00:00:00.000');
  const end = new Date(end_date + 'T23:59:59.999');

  const events = windows.map(window => {
    const start = new Date(window.start_at);
    const end = new Date(window.end_by);

    return {
      id: window.id,
      start: new Date(window.start_at),
      end: new Date(window.end_by),
      title: <Window {...window} start={start} end={end} />,
    }
  });
  
  return (
    <LoadingState loading={status === STATUS.PENDING}>
      <Calendar start={start} end={end} events={events} onEventMoved={moveWindow} />
    </LoadingState>
  );
};

Cycle.propTypes = {
  id: PropTypes.number,
  name: PropTypes.string,
  start_date: PropTypes.string,
  end_date: PropTypes.string,
  windows: PropTypes.array,
  moveWindow: PropTypes.func,
  status: PropTypes.string,
};

Cycle.defaultProps = {
  windows: [],
};

export default Cycle;
