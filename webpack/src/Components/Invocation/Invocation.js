import React, { useRef, useState, useMemo } from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const Invocation = ({ events, status }) => {
  const viewerRef = useRef();
  const [isStderrVisible, setStderrVisible] = useState(true);
  const [isStdoutVisible, setStdoutVisible] = useState(true);
  const [isDebugVisible, setDebugVisible] = useState(false);
  const [followStatus, setFollowStatus] = useState(status === 'running' ? 'active' : 'disabled');

  const lines = useMemo(() => {
    return events.flatMap(event => (
      event.event.replace(/\r\n/, "\n").replace(/\n$/, '').split("\n").map(line => (
        { event_type: event.event_type, event: line, timestamp: event.timestamp }
      )).filter((event) => (
        (event.event_type === 'stdout' && isStdoutVisible) ||
        (event.event_type === 'stderr' && isStderrVisible) ||
        (event.event_type === 'debug' && isDebugVisible)
      ))
    ));
  }, [events, isStderrVisible, isStdoutVisible, isDebugVisible]);

  const onScroll = ({ scrollDirection, scrollOffsetToBottom, scrollUpdateWasRequested }) => {
    if (!scrollUpdateWasRequested) {
      if (scrollOffsetToBottom < 1) {
        setFollowStatus('active');
      } else if (scrollDirection === 'backward') {
        setFollowStatus('paused');
      }
    }
  };

  return (
    <LogViewer
      ref={viewerRef}
      theme='dark'
      data={lines}
      toolbar={<InvocationLogToolbar
        isDebugVisible={isDebugVisible}
        setDebugVisible={setDebugVisible}
        isStderrVisible={isStderrVisible}
        setStderrVisible={setStderrVisible}
        isStdoutVisible={isStderrVisible}
        setStdoutVisible={setStdoutVisible}
      />}
      footer={<InvocationLogFooter followStatus={followStatus} setFollowStatus={setFollowStatus} />}
      onScroll={onScroll}
    />
  );
};

Invocation.propTypes = {
  events: PropTypes.arrayOf(PropTypes.shape({
    event_type: PropTypes.string.isRequired,
    event: PropTypes.string.isRequired,
    timestamp: PropTypes.string.isRequired,
  })),
  status: PropTypes.string,
};

Invocation.defaultProps = {
  events: [],
  status: 'pending',
};

export default Invocation;
