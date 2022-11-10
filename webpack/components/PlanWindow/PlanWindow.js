import React from 'react';
import PropTypes from 'prop-types';
import { LoadingState, Alert } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import { STATUS } from 'foremanReact/constants';

const PlanWindow = ({
  id,
  name,
  description,
  start_day,
  start_time,
  duration,
  plan_id,
  plan,
  groups,
  status
}) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error while loading the window, try refreshing the page.'
        )}
      </Alert>
    );
  }

  return (
    <LoadingState loading={status === STATUS.PENDING}>
      <PlanWindowCards {...props} />
      <hr/>
      <Groups groups={groups} />
    </LoadingState>
  );
};

PlanWindow.propTypes = {
  id: PropTypes.number,
  name: PropTypes.string,
  description: PropTypes.string,
  start_day: PropTypes.number,
  start_time: PropTypes.string,
  duration: PropTypes.number,
  plan_id: PropTypes.number,
  plan: PropTypes.object,
  groups: PropTypes.array,
  status: PropTypes.string.isRequired,
};

PlanWindow.defaultProps = {
  groups: [],
};

export default PlanWindow;
