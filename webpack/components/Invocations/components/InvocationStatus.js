import React from 'react';
import { Icon } from 'patternfly-react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const InvocationStatus = ({ state, result }) => {
  switch (state) {
    case 'stopped':
      switch (result) {
        case 'error':
          return (
            <div>
              <Icon type="pf" name="error-circle-o" /> {__('failed')}
            </div>
          );
        case 'warning':
          return (
            <div>
              <Icon type="pf" name="warning-triangle-o" /> {__('warning')}
            </div>
          );
        case 'success':
          return (
            <div>
              <Icon type="pf" name="ok" /> {__('success')}
            </div>
          );
        case 'cancelled':
          return (
            <div>
              <Icon type="fa" name="ban" /> {__('cancelled')}
            </div>
          );
        default:
          return (
            <div>
              <Icon type="fa" name="question" /> {__('unknown')}
            </div>
          );
      }
    case 'running':
      return (
        <div>
          <Icon type="pf" name="in-progress" /> {__('running')}
        </div>
      );
    default:
      return (
        <div>
          <Icon type="pf" name="pending" /> {__('pending')}
        </div>
      );
  }
};

InvocationStatus.propTypes = {
  state: PropTypes.string.isRequired,
  result: PropTypes.string.isRequired,
};

export default InvocationStatus;
