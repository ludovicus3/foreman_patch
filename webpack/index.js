/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
import componentRegistry from 'foremanReact/components/componentRegistry';
import Rounds from './components/Rounds';
import Plan from './components/Plan';
import Invocations from './components/Invocations';

const components = [
  { name: 'Rounds', type: Rounds },
  { name: 'Plan', type: Plan },
  { name: 'Invocations', type: Invocations },
];

components.forEach(component => componentRegistry.register(component));
