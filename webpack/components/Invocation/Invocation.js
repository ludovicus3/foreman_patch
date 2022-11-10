import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { Tabs, Tab, TabTitleText, LoadingState } from 'patternfly-react';
import { STATUS } from 'foremanReact/constants';

import Terminal from '../common/Terminal/Terminal';

const Invocation = ({ invocation, status }) => {
  if (status === STATUS.ERROR) {
    return (
      <Alert type="error">
        {__(
          'There was an error loading the invocation, try refreshing the page.'
        )}
      </Alert>
    );
  }

  const [activeTabKey, setActiveTabKey] = useState(0);

  const handleTabClick = (event, tabIndex) => {
    setActiveTabKey(tabIndex);
  };

  return (
    <LoadingState loading={status == STATUS.PENDING}>
      <Tabs activeKey={activeTabKey} onSelect={handleTabClick}>
        <Tab eventKey={0} title={<TabTitleText>Overview</TabTitleText>}>
          TODO: status
        </Tab>
        {invocation.phases.map((phase, index) => (
          <Tab event={index + 1} title={<TabTitleText>{phase.humanized_name}</TabTitleText>}>
            <Terminal key={phase.label} linesets={phase.live_output}/>
          </Tab>
        ))}
      </Tabs>
    </LoadingState>
  );
};

Invocation.propTypes = {
  status: PropTypes.string.isRequired,
  invocation: PropTypes.object.isRequired,
};

export default Invocation;
