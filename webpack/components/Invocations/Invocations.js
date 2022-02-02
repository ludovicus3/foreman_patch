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

  const rows = items.length ? (
    items.map(item => (<InvocationItem {...item} />))
  ) : (
    <tr>
      <td colSpan="3">{__('No hosts found.')}</td>
    </tr>
  );

  return (
    <LoadingState loading={!items.length && status === STATUS.PENDING}>
      <div>
        <table className="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>{__('Host')}</th>
              <th className="col-md-2">{__('Status')}</th>
              <th className="col-md-1">{__('Actions')}</th>
            </tr>
          </thead>
          <tbody>{rows}</tbody>
        </table>
      </div>
    </LoadingState>
  );
};

Invocations.propTypes = {
  status: PropTypes.string,
  items: PropTypes.array.isRequired,
};

Invocations.defaultProps = {
  status: null,
};

export default Invocations;
