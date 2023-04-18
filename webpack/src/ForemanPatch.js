import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import ForemanPatchRoute from './Router';

const ForemanPatch = () => (
  <BrowserRouter>
    <ForemanPatchRoute />
  </BrowserRouter>
);

export default ForemanPatch;
