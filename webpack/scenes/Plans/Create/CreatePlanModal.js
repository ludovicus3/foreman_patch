import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { Modal, ModalVariant } from '@patternfly/react-core';

import CreatePlanForm from './CreatePlanForm';

const CreatePlanModal = ({ show, setIsOpen }) => (
  <Modal
    ouiaId="create-plan-modal"
    title={__('Create patch plan')}
    variant={ModalVariant.small}
    isOpen={show}
    onClose={() => { setIsOpen(false); }}
    appendTo={document.body}
  >
    <CreatePlanForm setModalOpen={setIsOpen} />
  </Modal>
);

CreatePlanModal.propTypes = {
  show: PropTypes.bool,
  setIsOpen: PropTypes.func,
};

CreatePlanModal.defaultProps = {
  show: false,
  setIsOpen: null,
};

export default CreatePlanModal;
