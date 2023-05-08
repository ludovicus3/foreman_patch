import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { Link } from 'react-router-dom';
import { Button } from '@patternfly/react-core';
import { TableVariant, Thead, Tbody, Th, Tr, Td } from '@patternfly/react-table';

import { selectPlans, selectPlansStatus, selectPlansError } from '../PlansSelectors';

const PlansTable = () => {
    const dispatch = useDispatch();

    const response = useSelector(selectPlans);
    const status = useSelector(selectPlansStatus);
    const error = useSelector(selectPlansError);

    const [searchQuery, updateSearchQuery] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);

    return (
    );
};

export default PlansTable;