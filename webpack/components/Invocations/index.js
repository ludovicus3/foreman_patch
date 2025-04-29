import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import PropTypes from 'prop-types';

import { 
  withInterval,
  stopInterval
} from 'foremanReact/redux/middlewares/IntervalMiddleware';
import { get } from 'foremanReact/redux/API';
import { getURI } from 'foremanReact/common/urlHelpers';

import {
  selectItems,
  selectTotal,
  selectAutoRefresh,
  selectStatus,
  selectIntervalExists,
} from './InvocationsSelectors';
import { INVOCATIONS } from './InvocationsConstants';
import InvocationsPage from './InvocationsPage';

const WrappedInvocations = ({ round }) => {
  const dispatch = useDispatch();

  const items = useSelector(selectItems);
  const total = useSelector(selectTotal);
  const search = useSelector(selectSearch);
  const page = useSelector(selectPage);
  const perPage = useSelector(selectPerPage);
  const autoRefresh = useSelector(selectAutoRefresh);
  const status = useSelector(selectStatus);

  const [url, setUrl] = useState(getURI().path(`/foreman_patch/api/rounds/${round}/invocations`));
  const intervalExists = useSelector(selectIntervalExists);

  const handleSearch = search => {
    stopApiInterval();

    if (search) {
      setUrl(url.setQuery({search}));
    } else {
      setUrl(url.removeQuery('search'))
    }
  };

  const handlePagination = ({page, perPage}) => {
    stopApiInterval();
    setUrl(url.setQuery({page, per_page: perPage}));
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
      search={search}
      page={page}
      perPage={perPage}
      handleSearch={handleSearch}
      handlePagination={handlePagination}
    />
  );
};

WrappedInvocations.propTypes = {
  round: PropTypes.number.isRequired,
};

export default WrappedInvocations;

