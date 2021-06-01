/* eslint import/no-unresolved: [2, { ignore: [foremanReact/*] }] */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable import/extensions */
import componentRegistry from 'foremanReact/components/componentRegistry';
import WindowGroups from './components/WindowGroups';

const components = [
  { name: 'WindowGroups', type: WindowGroups },
];

components.forEach(component => componentRegistry.register(component));
