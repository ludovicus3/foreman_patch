/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
import componentRegistry from 'foremanReact/components/componentRegistry';
import Rounds from './components/Rounds';
import Calendar from './components/common/Calendar/Calendar';

const components = [
  { name: 'Rounds', type: Rounds },
  { name: 'Calendar', type: Calendar },
];

components.forEach(component => componentRegistry.register(component));
