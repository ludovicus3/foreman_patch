import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { DndProvider } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

import Priority from './Priority';
import { prioritizeGroups } from './GroupsHelpers';

const Groups = ({groups}) => {
  const [priorities, setPriorities] = useState(prioritizeGroups(groups));

  const moveGroup = (group, source, target, insert) => {
    const result = priorities;

    // insert the group into the correct priority
    if (insert) {
      // insert a new priority with the group
      result.splice(target, 0, [ group ]);
    } else {
      // add group to existing priority
      result[target].push(group);
    }

    // remove group from source priority
    result[source] = result[source].filter(e => (e !== group));

    // remove priority if it is empty
    if (result[source].length === 0) {
      result.splice(group.priority, 1);
    }

    setPriorities(result);
  };

  return (
    <DndProvider backend={HTML5Backend}>
      <div className="group-list">
        {priorities.map(groups, index => (
          <Priority priority={index} groups={groups} /> 
        ))}
      </div>
    </DndProvider>
  );
};

export default Groups;
