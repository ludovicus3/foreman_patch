import React from 'react';
import PropTypes from 'prop-types';
import { TableComposable, Thead, Tr, Th, Tbody, Td } from '@patternfly/react-table';

import { translate as __ } from 'foremanReact/common/I18n';
import { LoadingState, Alert } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';

const PlansTable = ({
    plans,
    status,
}) => {
    if (status === STATUS.ERROR) {
        return (
            <Alert type="error">
                {__(
                    'There was an error while loading plans, try refreshing the page.'
                )}
            </Alert>
        );
    }

    const rows = plans.length ? (
        plans.map(plan => (
            <Tr key={`plan-${plan.id}`}>
                <Td className="plan_name">
                    {plan.name}
                </Td>
                <Td>
                    {plan.description}
                </Td>
                <Td>
                    {plan.next_start_date}
                </Td>
                <Td>
                    {plan.interval}
                </Td>
                <Td>
                    {plan.cycles}
                </Td>
                <Td>
                    <PlanActions {...plan} />
                </Td>
            </Tr>
        ))
    ) : (
        <Tr>
            <Td colSpan={6}>{__('No plans found.')}</Td>
        </Tr>
    );

    return (
        <LoadingState loading={!plans.length && status === STATUS.PENDING}>
            <TableComposable>
                <Thead>
                    <Tr>
                        <Th md={2}>{__('Name')}</Th>
                        <Th md={4}>{__('Description')}</Th>
                        <Th md={1}>{__('Next Start')}</Th>
                        <Th md={1}>{__('Interval')}</Th>
                        <Th md={1}>{__('Cycles')}</Th>
                        <Th md={1}>{__('Actions')}</Th>
                    </Tr>
                </Thead>
                <Tbody>{rows}</Tbody>
            </TableComposable>
        </LoadingState>
    );
};

PlansTable.PropTypes = {
    plans: PropTypes.array.isRequired,
    status: PropTypes.string.isRequired,
};

export default PlansTable;