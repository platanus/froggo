import api from './index';

export default {
  checkSync(organizationId) {
    return api({
      method: 'get',
      url: `/api/v1/organizations/${organizationId}/check_sync`,
    });
  },
  sync(organizationId) {
    return api({
      method: 'post',
      url: `/api/v1/organizations/${organizationId}/sync`,
    });
  },
  update(organizationId, body) {
    return api({
      method: 'put',
      url: `/api/v1/organizations/${organizationId}/update`,
      data: body,
    });
  },
  createAll(body) {
    return api({
      method: 'post',
      url: '/api/v1/organizations/create_all',
      data: body,
    });
  },
};
