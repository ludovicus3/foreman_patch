import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState, Alert } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';
import GroupItem from './components/GroupItem';

const WindowGroups = ({ status, items }) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error while updating the status, try refreshing the page.'
        )}
      </Alert>
    );
  }

  return (
    <LoadingState loading={!items.length && status === STATUS.PENDING}>
      <div>
        <table className="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>{__('Group')}</th>
              <th>{__('Priority')}</th>
              <th>{__('Hosts Count')}</th>
              <th>{__('Status')}</th>
              <th>{__('Actions')}</th>
            </tr>
          </thead>
          <tbody>
            {items.map(group => (
              <GroupItem
                key={group.name}
                name={group.name}
                link={group.link}
                priority={group.priority}
                hostsCount={group.hostsCount}
                hostsLink={group.hostsLink}
                status={group.status}
                actions={group.actions}
              />
            ))}
          </tbody>
        </table>
      </div>
    </LoadingState>
  );
};

WindowGroups.propTypes = {
  status: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired,
};

export default WindowGroups;
