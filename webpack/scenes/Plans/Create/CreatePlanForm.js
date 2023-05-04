import React, { useState, useEffect } from 'react';
import useDeepCompareEffect from 'use-deep-compare-effect';
import PropTypes from 'prop-types';
import { useDispatch, useSelector } from 'react-redux';
import { Form, FormGroup, TextInput, TextArea, DatePicker, ActionGroup, Button } from '@patternfly/react-core';

import { STATUS } from 'foremanReact/constants';
import { translate as __ } from 'foremanReact/common/I18n';

import { createPlan } from '../PlansActions';
import { selectCreatePlan, selectCreatePlanStatus, selectCreatePlanError } from './CreatePlanSelectors';

const CreatePlanForm = ({ setModalOpen }) => {
  const dispatch = useDispatch();
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [cycleName, setCycleName] = useState('');
  const [startDate, setStartDate] = useState(new Date());
  const [interval, setInterval] = useState(1);
  const [units, setUnits] = useState('days');
  const [count, setCount] = useState(0);
  
  const [redirect, setRedirect] = useState(false);
  const [saving, setSaving] = useState(false);
  
  const response = useSelector(selectCreatePlan);
  const status = useSelector(selectCreatePlanStatus);
  const error = useSelector(selectCreatePlanError);
  
  useDeepCompareEffect(() => {
    const { id } = response;
    if (id && status === STATUS.RESOLVED && saving) {
      setSaving(false);
      setRedirect(true);
    } else if (status === STATUS.ERROR) {
      setSaving(false);
    }
  }, [response, status, error, saving]);
  
  const onSave = () => {
    setSaving(true);
    dispatch(createPlan({
      name,
      description,
      cycleName,
      startDate,
      interval,
      units,
      count,
    }));
  };
  
  if (redirect) {
    const { id } = response;
    window.location.assign(`/patch_plans/${id}`);
  }
  
  const submitDisabled = !name?.length || saving || redirect;
  
  return (
    <Form onSubmit={(e) => {
    }}
    >
      <FormGroup labal={__('Name')} isRequired fieldId="name">
        <TextInput
          isRequired
          type="text"
          id="name"
          aria-label="input_name"
          ouiaId="input_name"
          name="name"
          value={name}
          onChange={value => setName(value)}
        />
      </FormGroup>
      <FormGroup label={__('Description')} fieldId="description">
        <TextArea
          isRequired
          type="text"
          id="description"
          name="description"
          aria-label="input_description"
          value={description}
          onChange={value => setDescription(value)}
        />
      </FormGroup>
      <FormGroup label={__('Cycle Name Template')} fieldId="cycle_name">
        <TextInput
          type="text"
          id="cycle_name"
          aria-label="input_name"
          value={cycleName}
          onChange={value => setCycleName(value)}
        />
      </FormGroup>
      <FormGroup label={__('Start Date')} fieldId="start_date">
        <DatePicker
          id="start_date"
          aria-label="input_start_date"
          value={startDate}
          onChange={value => setStartDate(value)}
        />
      </FormGroup>
      <FormGroup label={__('Interval')} fieldId="interval">
      </FormGroup>
      <ActionGroup>
        <Button
          ouiaId="create-plan-form-submit"
          aria-label="create_plan_view"
          variant="primary"
          isDisable={submitDisabled}
          isLoading={saving || redirect}
          type="submit"
        >
          {__('Create plan')}
        </Button>
        <Button ouiaId="create-plan-form-cancel" variant="link" onClick={() => setModalOpen(false)}>
          {__('Cancel')}
        </Button>
      </ActionGroup>
    </Form>
  );
};

CreatePlanForm.propTypes = {
  setModalOpen: PropTypes.func,
};

CreatePlanForm.defaultProps = {
  setModalOpen: null,
};

export default CreatePlanForm;
