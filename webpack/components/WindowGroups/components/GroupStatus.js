import React from 'react';
import { Icon } from 'patternfly-react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const GroupStatus = ({ status }) => {
  switch (status) {
    case 'warning':
    case 'cancelled':
      return (
        <div>
          <Icon type="pf" name="warning-triangle-o" /> {status}
        </div>
      );
    case 'N/A':
      return (
        <div>
          <Icon type="fa" name="question" /> {status}
        </div>
      );
    case 'running':
      return (
        <div>
          <Icon type="pf" name="running" /> {status}
        </div>
      );
    case 'planned':
      return (
        <div>
          <Icon type="pf" name="build" /> {status}
        </div>
      );
    case 'error':
      return (
        <div>
          <Icon type="pf" name="error-circle-o" /> {__('failed')}
        </div>
      );
    case 'success':
      return (
        <div>
          <Icon type="pf" name="ok" /> {status}
        </div>
      );
    default:
      return <span>{status}</span>;
  }
};

GroupStatus.propTypes = {
  status: PropTypes.string.isRequired,
};

export default GroupStatus;
