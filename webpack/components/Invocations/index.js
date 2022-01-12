import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import PropTypes from 'prop-types';

import { 
  withInterval,
  stopInterval
} from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { get } from 'foremanReact/redux/API';
import { useForemanSettings } from 'foremanReact/Root/Context/ForemanContext';

import {
  selectItems,
  selectTotal,
  selectAutoRefresh,
  selectStatus,
  selectIntervalExists,
} from './InvocationsSelectors';
import { getUrl } from './InvocationsHelpers';
import { INVOCATIONS } from './InvocationsConstants';
import InvocationsPage from './InvocationsPage';

const WrappedInvocations = ({ round }) => {
  const dispatch = useDispatch();
  const { perPage, perPageOptions } = useForemanSettings();

  const items = useSelector(selectItems);
  const total = useSelector(selectTotal);
  const autoRefresh = useSelector(selectAutoRefresh);
  const status = useSelector(selectStatus);
  const [searchQuery, setSearchQuery] = useState('');
  const [pagination, setPagination] = useState({
    page: 1,
    perPage,
    perPageOptions,
  });
  const [url, setUrl] = useState(getUrl(round, searchQuery, pagination));
  const intervalExists = useSelector(selectIntervalExists);

  const handleSearch = query => {
    const defaultPagination = { page: 1, perPage: pagination.perPage };
    stopApiInterval();

    setUrl(getUrl(round, query, defaultPagination));
    setSearchQuery(query);
    setPagination(defaultPagination);
  };

  const handlePagination = args => {
    stopApiInterval();
    setPagination(args);
    setUrl(getUrl(round, searchQuery, args));
  };

  const stopApiInterval = () => {
    if (intervalExists) {
      dispatch(stopInterval(INVOCATIONS));
    }
  };

  const getData = url =>  withInterval(get({
    key: INVOCATIONS,
    url,
    handleError: () => {
      dispatch(stopInterval(INVOCATIONS));
    },
  }), 5000);

  useEffect(() => {
    dispatch(getData(url));

    if (!autoRefresh) {
      dispatch(stopInterval(INVOCATIONS));
    }

    return () => {
      dispatch(stopInterval(INVOCATIONS));
    };
  }, [dispatch, url, autoRefresh]);

  return (
    <InvocationsPage
      status={status}
      items={items}
      total={total}
      searchQuery={searchQuery}
      handleSearch={handleSearch}
      pagination={pagination}
      handlePagination={handlePagination}
    />
  );
};

WrappedInvocations.propTypes = {
  round: PropTypes.number.isRequired,
};

export default WrappedInvocations;

