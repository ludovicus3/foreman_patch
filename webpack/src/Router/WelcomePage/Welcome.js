import React from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import { Button, Alert } from '@patternfly/react-core';
import EmptyState from 'foremanReact/components/common/EmptyState/EmptyStatePattern';

const WelcomePage = () => {
  const createBtn = (
    <Button>TODO</Button>
  );

  const header = "Patching";

  const description = "The welcome page";

  return (
    <EmptyState
      icon="add-circle-o"
      action={createBtn}
      header={header}
      description={description}
      documentation={false}
    />
  );
};

export default WelcomePage;