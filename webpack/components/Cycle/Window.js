import React from 'react';
import PropTypes from 'prop-types';

const Window = ({id, name, description, start, end, locale, hour12}) => {
  const time = Intl.DateTimeFormat(locale, {
    hour: 'numeric', minute: 'numeric', hour12: hour12
  }).format(start);

  return (
    <div className="ellipsis">
      <a href={`/foreman_patch/windows/${id}`}>{time} {name}</a>
    </div>
  );
};

Window.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  start: PropTypes.instanceOf(Date).isRequired,
  end: PropTypes.instanceOf(Date).isRequired,
  locale: PropTypes.string,
  hour12: PropTypes.bool,
};

Window.defaultProps = {
  description: null,
  locale: 'en-US',
  hour12: true,
};

export default Window;
