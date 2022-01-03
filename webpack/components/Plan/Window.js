import React from 'react';
import PropTypes from 'prop-types';

const Window = ({id, name, description, start_day, start_time, locale, hour12}) => {
  const time = Intl.DateTimeFormat(locale, {
    hour: 'numeric', minute: 'numeric', hour12: hour12
  }).format(new Date(start_time));

  return (
    <div className="ellipsis">
      <a href={`/foreman_patch/window_plans/${id}`}>{time} {name}</a>
    </div>
  );
};

Window.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  start_day: PropTypes.number.isRequired,
  start_time: PropTypes.instanceOf(Date).isRequired,
  duration: PropTypes.number.isRequired,
  locale: PropTypes.string,
  hour12: PropTypes.bool,
};

Window.defaultProps = {
  description: null,
  locale: 'en-US',
  hour12: true,
};

export default Window;
