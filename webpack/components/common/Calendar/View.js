import Month from './Month';
import Week from './Week';
import Day from './Day';

export const views = {
  MONTH: 'month',
  WEEK: 'week',
  DAY: 'day',
};

export const VIEWS = {
  [views.MONTH]: Month,
  [views.WEEK]: Week,
  [views.DAY]: Day,
};

export const getView = (view) => {
  return VIEWS[view];
};

