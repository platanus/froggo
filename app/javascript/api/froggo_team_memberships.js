import api from './index';

export default {
  updateFroggoTeamMembership(froggoTeamMembershipId, body) {
    return api({
      method: 'patch',
      url: `/api/v1/froggo_team_memberships/${froggoTeamMembershipId}`,
      data: body,
    });
  },
  getFroggoTeamMemberships(githubUserId) {
    return api({
      method: 'get',
      url: `/api/v1/github_users/${githubUserId}/froggo_team_memberships`,
    });
  },
};
