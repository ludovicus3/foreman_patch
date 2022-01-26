import React from 'react';
import PropTypes from 'prop-types';
import { ActionButtons } from 'foremanReact/components/common/ActionButtons/ActionButtons';
import { translate as __ } from 'foremanReact/common/I18n';

import InvocationStatus from './InvocationStatus';

const InvocationItem = ({ id, name, state, result, task_id, host_id }) => {

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

  if (state == 'pending' && result == 'pending') {
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
    <tr id={`invocation-${id}`}>
      <td className="invocation_name">
        <a href={`/foreman_patch/invocations/${id}`}>{name}</a>
      </td>
      <td className="invocation_status">
        <InvocationStatus state={state} result={result} />
      </td>
      <td className="invocation_actions">
        <ActionButtons buttons={[...actions]} />
      </td>
    </tr>
  );
};

InvocationItem.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  state: PropTypes.string.isRequired,
  result: PropTypes.string.isRequired,
  host_id: PropTypes.number.isRequired,
  task_id: PropTypes.number.isRequired,
};

export default InvocationItem;
