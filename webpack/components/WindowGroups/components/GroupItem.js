import React from 'react';
import PropTypes from 'prop-types';
import { ActionButtons } from 'foremanReact/components/common/ActionButtons/ActionButtons';
import GroupStatus from './GroupStatus';

const GroupItem = ({ name, link, priority, hostsCount, hostsLink, status, actions }) => {
  const groupLink = link ? (
    <a href={link}>{name}</a>
  ) : (
    <a href="#" className="disabled">
      {name}
    </a>
  );

  const hostsCountLink = hostsLink ? (
    <a href={hostsLink}>{hostsCount}</a>
  ) : (
    <a href="#" className="disabled">
      {hostsCount}
    </a>
  );

  return (
    <tr id={`window-group-${name}`}>
      <td className="group_name">{groupLink}</td>
      <td className="group_priority">{priority}</td>
      <td className="group_hosts_count">{hostsCountLink}</td>
      <td className="group_status">
        <GroupStatus status={status} />
      </td>
      <td className="group_actions">
        <ActionButtons buttons={[...actions]} />
      </td>
    </tr>
  );
};

GroupItem.propTypes = {
  name: PropTypes.string.isRequired,
  link: PropTypes.string.isRequired,
  priority: PropTypes.number.isRequired,
  hostsCount: PropTypes.number.isRequired,
  hostsLink: PropTypes.string.isRequired,
  status: PropTypes.string.isRequired,
  actions: PropTypes.array,
};

GroupItem.defaultProps = {
  actions: [],
};

export default GroupItem;
