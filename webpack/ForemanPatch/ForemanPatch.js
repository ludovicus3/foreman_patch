import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import ForemanPatchRouter from './Routes/ForemanPatchRouter';

const ForemanPatch = () => (
  <BrowserRouter>
    <ForemanPatchRouter />
  </BrowserRouter>
);

export default ForemanPatch;
