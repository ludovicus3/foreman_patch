import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState, Alert } from 'patternfly-react';
import { TableComposable, Thead, Tr, Th, Tbody, Td } from '@patternfly/react-table';
import { STATUS } from 'foremanReact/constants';

import InvocationStatus from './components/InvocationStatus';
import InvocationActions from './components/InvocationActions';

const Invocations = ({ status, items, selectAll, areAllSelected, onSelect, isSelected }) => {
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
    items.map((item, rowIndex) => (
      <Tr key={`invocation-${item.id}`}>
        <Td
          select={{
            rowIndex,
            onSelect: (_event, isSelecting) => onSelect(item, rowIndex, isSelecting),
            isSelected: isSelected(item)
          }}
        />
        <Td className="invocation_name">
          <a href={`/foreman_patch/invocations/${item.id}`}>{item.name}</a>
        </Td>
        <Td>
          <InvocationStatus status={item.status}/>
        </Td>
        <Td>
          <InvocationActions {...item}/>
        </Td>
      </Tr>
    ))
  ) : (
    <Tr>
      <Td colSpan="4">{__('No hosts found.')}</Td>
    </Tr>
  );

  return (
    <LoadingState loading={!items.length && status === STATUS.PENDING}>
      <div>
        <TableComposable className="table table-bordered table-striped table-hover">
          <Thead>
            <Tr>
              <Th
                select={{
                  onSelect: (_event, isSelecting) => selectAll(isSelecting),
                  isSelected: areAllSelected
                }}
              />
              <Th>{__('Host')}</Th>
              <Th className="col-md-2">{__('Status')}</Th>
              <Th className="col-md-1">{__('Actions')}</Th>
            </Tr>
          </Thead>
          <Tbody>{rows}</Tbody>
        </TableComposable>
      </div>
    </LoadingState>
  );
};

Invocations.propTypes = {
  status: PropTypes.string,
  items: PropTypes.array.isRequired,
  selectAll: PropTypes.func.isRequired,
  areAllSelected: PropTypes.bool,
  onSelect: PropTypes.func.isRequired,
  isSelected: PropTypes.func.isRequired,
};

Invocations.defaultProps = {
  status: null,
  areAllSelected: false,
};

export default Invocations;
