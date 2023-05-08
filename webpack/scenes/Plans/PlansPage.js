import React from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import { Grid, GridItem, TextContent, Text, TextVariants } from '@patternfly/react-core';

import PlansTable from './Table/PlansTable';

const PlansPage = () => (
  <>
    <Grid className="margin-24">
      <GridItem span={12}>
        <TextContent>
          <Text ouiaId="planPageHeaderText" component={TextVariants.h1}>{__('Plans')}</Text>
        </TextContent>
      </GridItem>
    </Grid>
    <Grid>
      <GridItem span={12}>
        <PlansTable />
      </GridItem>
    </Grid>
  </>
);

export default PlansPage;
