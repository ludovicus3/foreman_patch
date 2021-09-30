/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
import componentRegistry from 'foremanReact/components/componentRegistry';
import Rounds from './components/Rounds';
import Plan from './components/Plan';

const components = [
  { name: 'Rounds', type: Rounds },
  { name: 'Plan', type: Plan },
];

components.forEach(component => componentRegistry.register(component));
