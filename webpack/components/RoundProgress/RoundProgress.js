import React from 'react';
import PropTypes from 'prop-types';
import Immutable from 'seamless-immutable';

import DonutChart from 'foremanReact/components/common/charts/DonutChart';
import { translate as __ } from 'foremanReact/common/I18n';

import AggregateStatus from './AggregateStatus';

const RoundProgress = ({ progress }) => {
  const data = [
    [__('Success'), progress.success, '#5CB85C'],
    [__('Warning'), progress.warning, '#DB843D'],
    [__('Failed'), progress.failed, '#D9534F'],
    [__('Running'), progress.running, '#3D96AE'],
    [__('Pending'), progress.pending, '#DEDEDE'],
    [__('Cancelled'), progress.cancelled, '#B7312D'],
  ];

  const iMax = data.reduce((im, e, i, arr) => 
    (e[1] > arr[im][i] ? i : im), 0);

  return (
    <div id="round_progress">
      <DonutChart 
        data={Immutable.asMutable(data)}
        title={{
          type: 'percent',
          secondary: (data[iMax] || [])[0],
        }}
      />
      <AggregateStatus progress={progress} />
    </div>
  );
};

RoundProgress.propTypes = {
  progress: PropTypes.shape({
    success: PropTypes.number,
    warning: PropTypes.number,
    failed: PropTypes.number,
    running: PropTypes.number,
    pending: PropTypes.number,
    cancelled: PropTypes.number,
  }).isRequired,
};

export default RoundProgress;
