import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState, Alert } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';
import RoundItem from './components/RoundItem';

const Rounds = ({ status, items }) => {
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
              <th>{__('Round')}</th>
              <th>{__('Priority')}</th>
              <th>{__('Hosts Count')}</th>
              <th>{__('Status')}</th>
              <th>{__('Actions')}</th>
            </tr>
          </thead>
          <tbody>
            {items.map(round => (
              <RoundItem
                key={round.name}
                name={round.name}
                link={round.link}
                priority={round.priority}
                hostsCount={round.hostsCount}
                hostsLink={round.hostsLink}
                status={round.status}
                actions={round.actions}
              />
            ))}
          </tbody>
        </table>
      </div>
    </LoadingState>
  );
};

Rounds.propTypes = {
  status: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired,
};

export default Rounds;
