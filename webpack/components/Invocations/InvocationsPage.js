import React from 'react';
import PropTypes from 'prop-types'
import { Grid } from 'patternfly-react';

import SearchBar from 'foremanReact/components/SearchBar';
import Pagination from 'foremanReact/components/Pagination/PaginationWrapper';
import { ActionButtons } form 'foremanReact/components/common/ActionButtons/ActionButtons';
import { getControllerSearchProps } from 'foremanReact/constants';

import Invocations from './Invocations';
import './InvocationsPage.scss';

const InvocationsPage = ({
  status,
  items,
  total,
  searchQuery,
  pagination,
  handleSearch,
  handlePagination,
  selectAll,
  areAllSelected,
  onSelect,
  isSelected,
  actions
}) => (
  <div id="patch_invocations">
    <Grid.Row>
      <Grid.Col md={6} className="title_filter">
        <SearchBar
          onSearch={handleSearch}
          data={{
            ...getControllerSearchProps('foreman_patch/invocations'),
            autocomplete: {
              id: 'invocations_search',
              searchQuery,
              url: '/foreman_patch/invocations/auto_complete_search',
              useKeyShortcuts: true,
            },
            bookmarks: {},
          }}
        />
      </Grid.Col>
      <Grid.Col md={6} className="title_action">
        <ActionButtons buttons={[]} />
      </Grid.Col>
    </Grid.Row>
    <br />
    <Invocations
      status={status}
      items={items}
      selectAll={selectAll}
      areAllSelected={areAllSelected}
      onSelect={onSelect}
      isSelected={isSelected}
    />
    <Pagination
      viewType="table"
      itemCount={total}
      pagination={pagination}
      onChange={handlePagination}
      dropdownButtonId="invocations-pagination-dropdown"
      className="invocations-pagination"
    />
  </div>
);

InvocationsPage.propTypes = {
  status: PropTypes.string,
  items: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  searchQuery: PropTypes.string.isRequired,
  pagination: PropTypes.object.isRequired,
  handleSearch: PropTypes.func.isRequired,
  handlePagination: PropTypes.func.isRequired,
  selectAll: PropTypes.func.isRequired,
  areAllSelected: PropTypes.bool,
  onSelect: PropTypes.func.isRequired,
  isSelected: PropTypes.func.isRequired,
  actions: PropTypes.array,
};

InvocationsPage.defaultProps = {
  status: null,
  areAllSelected: false,
  actions: []
};

export default InvocationsPage;
