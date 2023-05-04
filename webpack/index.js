/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
/* eslint-disable import/no-unresolved */
import componentRegistry from 'foremanReact/components/componentRegistry';
import ForemanPatch from './containers/ForemanPatch';

import Rounds from './components/Rounds';
import Plan from './components/Plan';
import Invocations from './components/Invocations';
import RoundProgress from './components/RoundProgress';
import Cycle from './components/Cycle';

import './redux';

const components = [
  { name: 'Rounds', type: Rounds },
  { name: 'Plan', type: Plan },
  { name: 'Invocations', type: Invocations },
  { name: 'Cycle', type: Cycle },
  { name: 'RoundProgress', type: RoundProgress },
];

components.forEach(component => componentRegistry.register(component));
componentRegistry.register({ name: 'ForemanPatch', type: ForemanPatch });
