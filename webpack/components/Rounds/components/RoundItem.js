import React from 'react';
import PropTypes from 'prop-types';
import { ActionButtons } from 'foremanReact/components/common/ActionButtons/ActionButtons';
import RoundStatus from './RoundStatus';

const RoundItem = ({ name, link, priority, hostsCount, hostsLink, status, actions }) => {
  const roundLink = link ? (
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
    <tr id={`round-${name}`}>
      <td className="round_name">{roundLink}</td>
      <td className="round_priority">{priority}</td>
      <td className="round_hosts_count">{hostsCountLink}</td>
      <td className="round_status">
        <RoundStatus status={status} />
      </td>
      <td className="round_actions">
        <ActionButtons buttons={[...actions]} />
      </td>
    </tr>
  );
};

RoundItem.propTypes = {
  name: PropTypes.string.isRequired,
  link: PropTypes.string.isRequired,
  priority: PropTypes.number.isRequired,
  hostsCount: PropTypes.number.isRequired,
  hostsLink: PropTypes.string.isRequired,
  status: PropTypes.string.isRequired,
  actions: PropTypes.array,
};

RoundItem.defaultProps = {
  actions: [],
};

export default RoundItem;
