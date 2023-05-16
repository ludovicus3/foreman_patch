import React, { useCallback, useRef } from 'react';
import useDeepCompareEffect from 'use-deep-compare-effect';
import PropTypes from 'prop-types';
import { useDispatch } from 'react-redux';

import { STATUS } from 'foremanReact/constants';
import { useForemanSettings } from 'foremanReact/Root/Context/ForemanContext';
import { translate as __ } from 'foremanReact/common/I18n';

import { getPageStats } from './helpers';

const TableWrapper = ({
    actionButtons,
    toggleGroup,
    children,
    metadata,
    fetchItems,
    autocompleteEndpoint,
    foremanApiAutoComplete,
    searchQuery,
    updateSearchQuery,
    additionalListeners
}) => {
    const dispatch = useDispatch();
    const foremanPerPage = useForemanSettings().perPage || 20;
    const perPage = Number(metadata?.per_page ?? foremanPerPage);
    const page = Number(metadata?.page ?? 1);
    const total = Number(metadata?.subtotal ?? 0);
    const { pageRowCount } = getPageStats({ total, page, perPage });
    const unresolvedStatus = !!allTableProps?.status && allTableProps.status !== STATUS.RESOLVED;

};