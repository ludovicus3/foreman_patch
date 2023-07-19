import React from 'react';
import PropTypes from 'prop-types';
import {
  ExclamationCircleIcon,
  ExclamationTriangleIcon,
  CheckCircleIcon,
  BanIcon,
  InProgressIcon,
  PendingIcon
} from '@patternfly/react-icons';
import { Label } from '@patternfly/react-core';

const InvocationStatus = ({ status }) => {
  switch (status) {
    case 'error':
      return (
        <Label icon={<ExclamationCircleIcon />}>{__('failed')}</Label>
      );
    case 'warning':
      return (
        <Label icon={<ExclamationTriangleIcon />}>{__('warning')}</Label>
      );
    case 'success':
      return (
        <Label icon={<CheckCircleIcon />}>{__('success')}</Label>
      );
    case 'cancelled':
      return (
        <Label icon={<BanIcon />}>{__('success')}</Label>
      );
    case 'running':
      return (
        <Label icon={<InProgressIcon />}>{__('running')}</Label>
      );
    default:
      return (
        <Label icon={<PendingIcon />}>{__('pending')}</Label>
      );
  }
};

InvocationStatus.propTypes = {
  status: PropTypes.string,
};

InvocationStatus.defaultProps = {
  status: 'pending',
};

export default InvocationStatus;