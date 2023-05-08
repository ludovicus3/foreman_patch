import React, { useCallback, useRef } from 'react';
import PropTypes from 'prop-types';
import { useDispatch } from 'react-redux';
import { PaginationVariant, Flex, FlexItem } from '@patternfly/react-core';

import { STATUS } from 'foremanReact/constants';
import { useForemanSettings } from 'foremanReact/Root/Context/ForemanContext';
import { translate as __ } from 'foremanReact/common/I18n';

import { SelectAllCheckbox }

const TableWrapper = ({

}) => {
    const dispatch = useDispatch();

    return (
        <>
            <Flex style={{ alignItems: 'center' }} className="margin-16-24">
                { displaySelectAllCheckbox && !hideToolbar && 
                    <FlexItem alignSelf={{ default: 'alignSelfCenter' }}>
                        <SelectAllCheckbox
                    </FlexItem>
                }
            </Flex>
        </>
    );
}