import React from 'react';
import PropTypes from 'prop-types';

const AggregateStatus = ({ progress }) => (
  <div id="aggregate_statuses">
    <p className="card-pf-aggregate-status-notifications">
      <span className="card-pf-aggregate-status-notification">
        <span id="success_count">
          <span className="pficon pficon-ok" />
          {progress.success}
        </span>
      </span>
      <span className="card-pf-aggregate-status-notification">
        <span id="warning_count">
          <span className="pficon pficon-warning-triangle-o" />
          {progress.warning}
        </span>
      </span>
      <span className="card-pf-aggregate-status-notification">
        <span id="failed_count">
          <span className="pficon pficon-error-circle-o" />
          {progress.error}
        </span>
      </span>
      <span className="card-pf-aggregate-status-notification">
        <span id="running_count">
          <span className="pficon pficon-running" />
          {progress.running}
        </span>
      </span>
      <span className="card-pf-aggregate-status-notification">
        <span id="pending_count">
          <span className="pficon pficon-pending" />
          {progress.pending + progress.planned}
        </span>
      </span>
      <span className="card-pf-aggregate-status-notification">
        <span id="cancelled_count">
          <span className="pficon pficon-close" />
          {progress.cancelled}
        </span>
      </span>
    </p>
  </div>
);

AggregateStatus.propTypes = {
  progress: PropTypes.shape({
    planned: PropTypes.number,
    pending: PropTypes.number,
    running: PropTypes.number,
    success: PropTypes.number,
    warning: PropTypes.number,
    error: PropTypes.number,
    cancelled: PropTypes.number,
  }).isRequired,
};

export default AggregateStatus;
