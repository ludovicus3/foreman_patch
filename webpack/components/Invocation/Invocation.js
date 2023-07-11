import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';

import Terminal from '../common/Terminal/Terminal';

const Invocation = ({ invocation, status }) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error loading the invocation, try refreshing the page.'
        )}
      </Alert>
    );
  }

  return (
    <LoadingState loading={status == STATUS.PENDING}>
      <Button>
        {__('Toggle STDERR')}
      </Button>
      <Terminal />
    </LoadingState>
  );
};

Invocation.propTypes = {
  status: PropTypes.string.isRequired,
  invocation: PropTypes.object.isRequired,
};

export default Invocation;
