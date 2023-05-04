import React from 'react';
import { Switch, Route } from 'react-router-dom';

import routes from './config';

const Router = () => (
  <Switch>
    {links.map(({ path, component, exact = true}) => (
      <Route exact={exact} key={key} path={`/${path}`} component={component} />
    ))}
  </Switch>
);

export default Router;
