import { getURI } from 'foremanReact/common/urlHelpers';

export const getUrl = (searchQuery, pagination) => {
  const baseUrl = getURI()
    .path('/foreman_patch/api/plans')
    .search('')
    .addQuery('page', pagination.page)
    .addQuery('per_page', pagination.perPage);

  return searchQuery ? baseUrl.addQuery('search', searchQuery) : baseUrl;
};
