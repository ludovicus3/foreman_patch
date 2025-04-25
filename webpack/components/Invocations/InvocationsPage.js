import React from 'react';
import PropTypes from 'prop-types'
import { Grid } from 'patternfly-react';

import SearchBar from 'foremanReact/components/SearchBar';
import Pagination from 'foremanReact/components/Pagination';
import { getControllerSearchProps } from 'foremanReact/constants';

import Invocations from './Invocations';
import './InvocationsPage.scss';

const InvocationsPage = ({
  status,
  items,
  total,
  search,
  page,
  perPage,
  handleSearch,
  handlePagination,
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
              searchQuery: search,
              url: '/foreman_patch/invocations/auto_complete_search',
              useKeyShortcuts: true,
            },
            bookmarks: {},
          }}
        />
      </Grid.Col>
    </Grid.Row>
    <br />
    <Invocations status={status} items={items} />
    <Pagination
      viewType="table"
      itemCount={total}
      page={page}
      perPage={perPage}
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
  search: PropTypes.string.isRequired,
  page: PropTypes.number.isRequired,
  perPage: PropTypes.number.isRequired,
  handleSearch: PropTypes.func.isRequired,
  handlePagination: PropTypes.func.isRequired,
};

InvocationsPage.defaultProps = {
  status: null,
  search: '',
  page: 1,
  perPage: 25,
};

export default InvocationsPage;
