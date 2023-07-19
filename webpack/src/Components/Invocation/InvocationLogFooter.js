import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { OutlinedPlayCircleIcon } from '@patternfly/react-icons';
import { Button } from '@patternfly/react-core';
import classNames from 'classnames';

const InvocationFooter = ({ followStatus, setFollowStatus }) => {
  const resumeFollowing = () => setFollowStatus('active');

  return (
    <Button className={classNames('invocation__footer', {
      'invocation__footer--hidden': followStatus !== 'paused',
    })} onClick={resumeFollowing} isBlock >
      <OutlinedPlayCircleIcon />
      &nbsp{__('Resume following')}
    </Button>
  );
};

InvocationFooter.propTypes = {
  followStatus: PropTypes.string,
  setFollowStatus: PropTypes.func.isRequired,
};

InvocationFooter.defaultProps = {
  followStatus: 'disabled',
};

export default InvocationFooter;