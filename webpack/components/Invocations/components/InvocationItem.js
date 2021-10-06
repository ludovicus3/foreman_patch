import React from 'react';
import PropTypes from 'prop-types';
import { ActionButtons } from 'foremanReact/components/common/ActionButtons/ActionButtons';
import InvocationStatus from './InvocationStatus';

const InvocationItem = ({ name, link, status, actions }) => {
  const invocationLink = link ? (
    <a href={link}>{name}</a>
  ) : (
    <a href="#" className="disabled">
      {name}
    </a>
  );

  return (
    <tr id={`invocation-${name}`}>
      <td className="invocation_name">{invocationLink}</td>
      <td className="invocation_status">
        <InvocationStatus status={status} />
      </td>
      <td className="invocation_actions">
        <ActionButtons buttons={[...actions]} />
      </td>
    </tr>
  );
};

InvocationItem.propTypes = {
  name: PropTypes.string.isRequired,
  link: PropTypes.string.isRequired,
  status: PropTypes.string.isRequired,
  actions: PropTypes.array,
};

InvocationItem.defaultProps = {
  actions: [],
};

export default InvocationItem;
