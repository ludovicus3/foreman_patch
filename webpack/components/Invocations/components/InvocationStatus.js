import React from 'react';
import { Icon } from 'patternfly-react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const InvocationStatus = ({ status }) => {
  switch (status) {
    case 'error':
      return (
        <div>
          <Icon type="pf" name="error-circle-o" /> {__('failed')}
        </div>
      );
    case 'warning':
      return (
        <div>
          <Icon type="pf" name="warning-triangle-o" /> {status}
        </div>
      );
    case 'moved':
      return (
        <div>
          <Icon type="pf" name="export" /> {status}
        </div>
      );
    case 'retried':
      return (
        <div>
          <Icon type="pf" name="history" /> {status}
        </div>
      );
    case 'cancelled':
      return (
        <div>
          <Icon type="fa" name="ban" /> {status}
        </div>
      );
    case 'success':
      return (
        <div>
          <Icon type="pf" name="ok" /> {status}
        </div>
      );
    case 'running':
      return (
        <div>
          <Icon type="pf" name="in-progress" /> {status}
        </div>
      );
    case 'pending':
      return (
        <div>
          <Icon type="pf" name="pending" /> {status}
        </div>
      );
    default:
      return (
        <div>
          <Icon type="fa" name="question" /> {status}
        </div>
      );
  }
};

InvocationStatus.propTypes = {
  status: PropTypes.string.isRequired,
};

export default InvocationStatus;
