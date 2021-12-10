import { chunk, times } from 'lodash';

export const addDays = (date, days) => {
  let result = new Date(date.valueOf());
  result.setDate(result.getDate() + days);
  return result;
};

export const addMonths = (date, months) => {
  let result = new Date(date.valueOf());
  result.setMonth(result.getMonth() + months);
  return result;
};

export const startOfDay = (date = new Date()) => {
  let result = new Date(date.valueOf());
  result.setHours(0, 0, 0, 0);
  return result;
};

export const endOfDay = (date = new Date()) => {
  let result = new Date(date.valueOf());
  result.setHours(23, 59, 59, 999);
  return result;
};

export const isEqualDate = (a, b) => {
  return a.getFullYear() === b.getFullYear() &&
    a.getMonth() === b.getMonth() &&
    a.getDate() === b.getDate();
};

export const startOfWeek = (date, weekStartsOn = 0) => {
  let day = date.getDay();
  let diff = day >= weekStartsOn ? day - weekStartsOn : 7 - weekStartsOn + day;
  let result = new Date(date.valueOf());
  result.setDate(result.getDate() - diff);
  result.setHours(0, 0, 0, 0);
  return result;
};

export const endOfWeek = (date, weekStartsOn = 0) => {
  let day = date.getDay();
  let diff = day >= weekStartsOn ? 6 - day + weekStartsOn : weekStartsOn - day - 1;
  let result = new Date(date.valueOf());
  result.setDate(result.getDate() + diff);
  result.setHours(23, 59, 59, 999);
  return result;
};

export const startOfMonth = (date) => {
  return new Date(date.getFullYear(), date.getMonth(), 1);
};

export const endOfMonth = (date) => {
  let result = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  result.setHours(23, 59, 59, 999);
  return result;
};

export const getWeekArray = (weekStartsOn, locale) => {
  let weekStart = startOfWeek(new Date(), weekStartsOn);

  return times(7, i => Intl.DateTimeFormat(locale, { weekday: 'long' })
    .format(addDays(weekStart, i)));
};

export const getWeeksOfMonth = (date, weekStartsOn = 0) => {
  let start = startOfMonth(date);
  let end = endOfMonth(date);
  let offset = start.getDay() - weekStartsOn;
  let days = offset + end.getDate() + (6 + weekStartsOn - end.getDay())

  return chunk(times(days, i => addDays(start, i - offset)), 7);
};


