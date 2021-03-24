import api from './index';

export default {
  checkSync(organizationId) {
    return api({
      method: 'get',
      url: `/api/organizations/${organizationId}/check_sync`,
    });
  },
  sync(organizationId) {
    return api({
      method: 'post',
      url: `/api/organizations/${organizationId}/sync`,
    });
  },
  update(organizationId, body) {
    return api({
      method: 'put',
      url: `/api/organizations/${organizationId}/update`,
      data: body,
    });
  },
};
