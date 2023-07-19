import React from 'react';
import PropTypes from 'prop-types';
import {
  Toolbar,
  ToolbarContent,
  ToolbarGroup,
  ToolbarItem,
  ToggleGroup,
  ToggleGroupItem
} from '@patternfly/react-core';
import { LogViewerSearch } from '@patternfly/react-log-viewer';
import { translate as __ } from 'foremanReact/common/I18n';

const InvocationLogToolbar = ({
  status,
  isDebugVisible,
  setDebugVisible,
  isStderrVisible,
  setStderrVisible,
  isStdoutVisible,
  setStdoutVisible,
}) => {
  return (
    <Toolbar>
      <ToolbarContent>
        <ToolbarGroup alignment={{ default: 'alignLeft' }}>
          <ToolbarItem>
            <InvocationStatus status={status} />
          </ToolbarItem>
        </ToolbarGroup>
        <ToolbarGroup alignement={{ default: 'alignRight' }}>
          <ToolbarItem>
            <LogViewerSearch placeholder={__('Search')} />
          </ToolbarItem>
          <ToolbarItem>
            <ToggleGroup>
              <ToggleGroupItem
                text={__('Toggle STDERR')}
                isSelected={isStderrVisible}
                onChange={setStderrVisible}
              />
              <ToggleGroupItem
                text={__('Toggle STDOUT')}
                isSelected={isStdoutVisible}
                onChange={setStdoutVisible}
              />
              <ToggleGroupItem
                text={__('Toggle DEBUG')}
                isSelected={isDebugVisible}
                onChange={setDebugVisible}
              />
            </ToggleGroup>
          </ToolbarItem>
        </ToolbarGroup>
      </ToolbarContent>
    </Toolbar>
  );
};

InvocationLogToolbar.propTypes = {
  status: PropTypes.string,
  isDebugVisible: PropTypes.bool,
  setDebugVisible: PropTypes.func,
  isStderrVisible: PropTypes.bool,
  setStderrVisible: PropTypes.func,
  isStdoutVisible: PropTypes.bool,
  setStdoutVisible: PropTypes.func,
};

InvocationLogToolbar.defaultProps = {
  status: 'pending',
  isDebugVisible: false,
  setDebugVisible: Function.prototype,
  isStderrVisible: true,
  setStderrVisible: Function.prototype,
  isStdoutVisible: true,
  setStdoutVisible: Function.prototype,
};

export default InvocationLogToolbar;