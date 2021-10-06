import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState, Alert } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';
import InvocationItem from './components/InvocationItem';

const Invocations = ({ status, items }) => {
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
              <th>{__('Host')}</th>
              <th>{__('Status')}</th>
              <th>{__('Actions')}</th>
            </tr>
          </thead>
          <tbody>
            {items.map(round => (
              <InvocationItem
                key={round.name}
                name={round.name}
                link={round.link}
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

Invocations.propTypes = {
  status: PropTypes.string.isRequired,
  items: PropTypes.array.isRequired,
};

export default Invocations;
