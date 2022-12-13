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
  const [selectedItems, setSelectedItems] = useState([]);
  const [recentSelectedItemIndex, setRecentSelectedRowIndex] = useState(null);
  const [shifting, setShifting] = useState(false);

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

  const selectAll = (isSelecting) => setSelectedItems(isSelecting ? items.map(item => item.id) : []);

  const areAllSelected = selectedItems.length == items.length;

  const setItemSelected = (item, isSelecting) => 
    setSelectedItems(prevSelected => {
      const otherSelectedItems = prevSelected.filter(i => i !== item.id);
      return isSelecting ? [...otherSelectedItems, item.id] : otherSelectedItems;
    });

  const onSelect = (item, rowIndex, isSelecting) => {
    if (shifting && recentSelectedRowIndex !== null) {
      const numberSelected = rowIndex - recentSelectedRowIndex;
      const intermediateIndexes =
        numberSelected > 0
        ? Array.from(new Array(numberSelected + 1), (_x, i) => i + recentSelectedRowIndex)
        : Array.from(new Array(Math.abs(numberSelected) + 1), (_x, i) => i + rowIndex);
      intermediateIndexes.forEach(index, setItemSelected(items[index], isSelecting));
    } else {
      setItemSelected(item, isSelecting);
    }
    setRecentSelectedRowIndex(rowIndex);
  };

  const isSelected = item => selectedItems.includes(item.id);

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
    const onKeyDown = (e) => {
      if (e.key === 'Shift') {
        setShifting(true);
      }
    };
    const onKeyUp = (e) => {
      if (e.key === 'Shift') {
        setShifting(false);
      }
    };

    dispatch(getData(url));

    if (!autoRefresh) {
      dispatch(stopInterval(INVOCATIONS));
    }

    document.addEventListener('keydown', onKeyDown);
    document.addEventListener('keyup', onKeyUp);

    return () => {
      dispatch(stopInterval(INVOCATIONS));
      document.removeEventListener('keydown', onKeyDown);
      document.removeEventListener('keyup', onKeyUp);
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
      selectAll={selectAll}
      areAllSelected={areAllSelected}
      onSelect={onSelect}
      isSelected={isSelected}
    />
  );
};

WrappedInvocations.propTypes = {
  round: PropTypes.number.isRequired,
};

export default WrappedInvocations;

