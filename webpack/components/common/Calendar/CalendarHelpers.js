import { times } from 'lodash';

export const isPastDate = (a, b = new Date()) => 
  a.setUTCHours(0, 0, 0, 0) < b.setUTCHours(0, 0, 0, 0);

export const isFutureDate = (a, b = new Date()) =>
  a.setUTCHours(0, 0, 0, 0) > b.setUTCHours(0, 0, 0, 0);

export const isEqualDate = (a, b) =>
  a.getFullYear() === b.getFullYear() &&
  a.getMonth() === b.getMonth() &&
  a.getDate() === b.getDate();

export const addDays = (date, days) => {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
};

export const addMonths = (date, months) => {
  const result = new Date(date);
  result.setMonth(result.getMonth() + months);
  return result;
};

export const getMonthStart = (date) => {
  date.setDate(1);
  return date;
};

export const getWeekStart = (date) => addDays(date, (7 - date.getDay()) % 7);

export const getWeekArray = (weekStartsOn, locale) => {
  const weekStart = getWeekStart(new Date());
  
  return times(7, i => 
    Intl.DateTimeFormat(locale, { weekday: 'long' })
      .format(addDays(weekStart, (i + weekStartsOn) % 7))
  );
};
