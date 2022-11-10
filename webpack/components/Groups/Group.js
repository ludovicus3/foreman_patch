import React from 'react'
import PropTypes from 'prop-types'
import { useDrag } from 'react-dnd'

import { GROUP } from './GroupsConstants'

const Group = (props) => {
  const [, drag] = useDrag({
    type: GROUP,
    item: {
      ...props
    },
  });

  return (
    <span ref={drag}></span>
  );
};

export default Group;
