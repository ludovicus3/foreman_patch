import { registerReducer } from 'foremanReact/common/MountingService';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';
import { registerRoutes } from 'foremanReact/routes/RoutingService';
import Routes from './src/Router/routes';
import reducers from './src/reducers';

// register reducers
Object.entries(reducers).forEach(([key, reducer]) =>
    registerReducer(key, reducer)
);

// register client routes
registerRoutes('ForemanPatch', Routes);

// register fills for extending foreman core
//addGlobalFill();