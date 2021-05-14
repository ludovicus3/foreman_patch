import React from 'react';
import { Switch, Route } from 'react-router-dom';

import routes from './ForemanPatchRoutes';

const ForemanPatchRouter = () => (
  <Switch>
    {Object.entries(routes).map(([key, props]) => (
      <Route key={key} {...props} />
    ))}
  </Switch>
);

export default ForemanPatchRouter;

