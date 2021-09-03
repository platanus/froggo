import api from './index';

export default {
  updateUser(userId, body) {
    return api({
      method: 'patch',
      url: `/api/v1/github_users/${userId}`,
      data: body,
    });
  },
  getUserRecommendations(teamId, userLogin, queryParams) {
    return api({
      method: 'get',
      url: `/api/v1/teams/${teamId}/users/${userLogin}/recommendations`,
      params: queryParams,
    });
  },
  pullRequestsInformation(userLogin, monthLimit) {
    return api({
      method: 'get',
      url: `/api/v1/users/${userLogin}/pull_requests_information`,
      params: { monthLimit },
    });
  },
  getUsersFromFroggoTeam(froggoTeamId) {
    return api({
      method: 'get',
      url: `/api/v1/froggo_teams/${froggoTeamId}/users`,
    });
  },
};
