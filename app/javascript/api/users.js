import api from './index';

export default {
  updateUser(userId, body) {
    return api({
      method: 'patch',
      url: `/api/github_users/${userId}`,
      data: body,
    });
  },
  getUserRecommendations(teamId, userLogin, queryParams) {
    return api({
      method: 'get',
      url: `/api/teams/${teamId}/users/${userLogin}/recommendations`,
      params: queryParams,
    });
  },
  pullRequestsInformation(userLogin, monthLimit) {
    return api({
      method: 'get',
      url: `/api/users/${userLogin}/pull_requests_information`,
      params: { monthLimit },
    });
  },
};
