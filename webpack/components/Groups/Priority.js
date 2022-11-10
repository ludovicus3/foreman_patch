import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { useDrop } from 'react-dnd';

import { GROUP } from './GroupConstants';

const Priority = ({priority, groups}) => {
  const [, drop] = useDrop({
    accept: GROUP,
    hover(item, monitor) {
      const sourcePriority = item.priority
      const targetPriority = priority

      if (groups.length === 1 && sourcePriority === targetPriority) {
        return
      }

      // Determine rectangle on screen
      const hoverBoundingRect = ref.current?.getBoundingClientRect()

      // Three vertical zones
      // 1: top 25% - insert above
      // 2: middle 50% - drop into
      // 3: bottom 25% - insert below
      // This results in 2 Y boundaries
      const hoverAboveY = (hoverBoundingRect.bottom - hoverBoundingRect.top) * 0.25
      const hoverBelowY = (hoverBoundingRect.bottom - hoverBoundingRect.top) * 0.75

      // Determine mouse position
      const clientOffset = monitor.getClientOffset()

      // Get pixes from the top
      const hoverClientY = clientOffset.y - hoverBoundingRect.top
      
      const targetPriority = hoverPriority

      moveGroup(group, targetPriority, insert)
      group.priority = hoverPriority
    }
  });

  return (
    <div ref={drop}>
      {groups.map(group => (
        <Group priority={priority} group={group} />
      ))}
    </div>
  );
};

export default Priority;
