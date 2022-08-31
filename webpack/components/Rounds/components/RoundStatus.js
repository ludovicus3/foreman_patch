import React from 'react';
import { Icon } from 'patternfly-react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const RoundStatus = ({ status }) => {
  switch (status) {
    case 'complete':
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
    case 'planned':
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

RoundStatus.propTypes = {
  status: PropTypes.string.isRequired,
};

export default RoundStatus;
