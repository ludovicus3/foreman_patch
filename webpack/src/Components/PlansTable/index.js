import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid } from 'patternfly-react';

import SearchBar from 'foremanReact/components/SearchBar';
import Pagination from 'foremanReact/components/Pagination/PaginationWrapper';
import { useForemanSettings } from 'foremanReact/Root/Context/ForemanContext';

import { getUrl } from './PlansTableHelpers';
import {
    selectPlans,
    selectTotal,
    selectStatus,
} from './PlansTableSelectors';
import { getData } from './PlansTableActions';
import { PLANS } from './PlansTableConsts';

function WrappedPlansTable() {
    const dispatch = useDispatch();
    const { perPage, perPageOptions } = useForemanSettings();

    const plans = useSelector(selectPlans);
    const total = useSelector(selectTotal);
    const status = useSelector(selectStatus);
    const [searchQuery, setSearchQuery] = useState('');
    const [pagination, setPagination] = useState({
        page: 1,
        perPage,
        perPageOptions,
    });
    const [url, setUrl] = useState(getUrl(searchQuery, pagination));

    const handleSearch = query => {
        const defaultPagination = { page: 1, perPage: pagination.perPage };
        setUrl(getUrl(query, defaultPagination));
        setSearchQuery(query);
        setPagination(defaultPagination);
    };

    const handlePagination = args => {
        setPagination(args);
        setUrl(getUrl(searchQuery, args));
    };

    useEffect(() => {
        dispatch(getData(url));
        return () => {
            dispatch(stopInterval(PLANS));
        };
    }, [dispatch, url]);

    return (
        <>
            <Grid.Row>
                <Grid.Col md={6} className="title_filter">
                    <SearchBar
                        onSearch={handleSearch}
                        data={{
                            ...getControllerSearchProps('foreman_patch/plans'),
                            autocomplete: {
                                id: 'plans_search',
                                searchQuery,
                                url: '/foreman_patch/plans/auto_complete_search',
                                useKeyShortcuts: true,
                            },
                            bookmarks: {},
                        }} />
                </Grid.Col>
                <Grid.Col md={6}>
                    <ActionButtons buttons={actions} />
                </Grid.Col>
            </Grid.Row>
            <br />
            <PlansTable
                status={status}
                plans={plans} />
            <Pagination
                viewType="table"
                itemCount={total}
                pagination={pagination}
                onChange={handlePagination}
                dropdownButtonId="plans-pagination-dropdown"
                className="plans-pagination" />
        </>
    );
}

export default WrappedPlansTable;