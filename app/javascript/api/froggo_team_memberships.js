import api from './index';

export default {
  getFroggoTeamMemberships(githubUserId) {
    return api({
      method: 'get',
      url: `/api/v1/github_users/${githubUserId}/froggo_team_memberships`,
    });
  },
  updateFroggoTeamMembership(froggoTeamMembershipId, body) {
    return api({
      method: 'patch',
      url: `/api/v1/froggo_team_memberships/${froggoTeamMembershipId}`,
      data: body,
    });
  },
  updateAllFroggoTeamMemberships(githubUserId, body) {
    return api({
      method: 'patch',
      url: `/api/v1/github_users/${githubUserId}/froggo_team_memberships`,
      data: body,
    });
  },
};
