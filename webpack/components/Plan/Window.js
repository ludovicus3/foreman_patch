import React from 'react';
import PropTypes from 'prop-types';

class Window extends React.Component {
  get date() {
    return this.props.start;
  }

  set date(value) {
    this.props.start = value;
 }

  move(newDate) {
    this.date = newDate;
  }

  render() {
    const { id, link, name, description, start, end } = this.props;

    const time = Intl.DateTimeFormat('en-US', {
      hour: 'numeric', minute: 'numeric', hour12: true
    }).format(new Date(start));

    return (
      <div className="ellipsis">
        <a href={link}>{time} {name}</a>
      </div>
    );
  }
};

Window.propTypes = {
  id: PropTypes.number.isRequired,
  link: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  start: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]).isRequired,
  end: PropTypes.oneOfType([PropTypes.instanceOf(Date), PropTypes.string]),
};

Window.defaultProps = {
  description: null,
  end: null
};

export default Window;
