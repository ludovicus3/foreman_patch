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
        id: `${name}-actions-task`,
      }
    }
  ];

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
