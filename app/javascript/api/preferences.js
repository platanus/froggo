import api from './index';

export default {
  getPreferences(userId) {
    return api({
      method: 'get',
      url: `/api/v1/github_users/${userId}/preferences`,
    });
  },
  updatePreferences(userId, body) {
    return api({
      method: 'patch',
      url: `/api/v1/github_users/${userId}/preferences`,
      data: body,
    });
  },
};
