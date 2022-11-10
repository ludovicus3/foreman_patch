import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { classnames } from 'classname';

const OutputLine = ({index, type, children}) => {
  return (
    <div className={classnames('line', type)} >
      <span className="counter">{index}</span>
      <div className="content">
        {children}
      </div>
    </div>
  );
};

OutputLine.propTypes = {
  index: PropTypes.number.isRequired,
  type: PropTypes.string,
  timestamp: PropTypes.number,
};

OutputLine.defaultProps = {
  type: 'stdout',
};

export default OutputLine;
