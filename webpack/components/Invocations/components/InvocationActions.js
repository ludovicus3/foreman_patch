import React from 'react';
import PropTypes from 'prop-types';
import { ActionButtons } from 'foremanReact/components/common/ActionButtons/ActionButtons';
import { translate as __ } from 'foremanReact/common/I18n';

const InvocationActions = ({ id, name, status, task_id, host_id }) => {

  const actions = [
    {
      title: __('Host Detail'),
      action: {
        href: `/hosts/${name}`,
        'data-method': 'get',
        id: `${name}-actions-host`,
      }
    },
  ];

  if (task_id) {
    actions.push({
      title: __('Task Detail'),
      action: {
        href: `/foreman_tasks/tasks/${task_id}`,
        'data-method': 'get',
        id: `${name}-actions-task`,
      },
    });
  }

  if (status == 'pending') {
    actions.push({
      title: __('Cancel'),
      action: {
        href: `/foreman_patch/invocations/${id}`,
        'data-method': 'delete',
        id: `${name}-actions-cancel`,
      }
    });
  }

  return (
    <ActionButtons buttons={[...actions]} />
  );
};

InvocationActions.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  status: PropTypes.string.isRequired,
  host_id: PropTypes.number.isRequired,
  task_id: PropTypes.number.isRequired,
};

export default InvocationActions;
