import api from './index';

export default {
  createFroggoTeam(organizationId, body) {
    return api({
      method: 'post',
      url: `/api/organizations/${organizationId}/froggo_teams`,
      data: body,
    });
  },
  updateFroggoTeam(teamId, body) {
    return api({
      method: 'patch',
      url: `/api/froggo_teams/${teamId}`,
      data: body,
    });
  },
  deleteFroggoTeam(teamId) {
    return api({
      method: 'delete',
      url: `/api/froggo_teams/${teamId}`,
    });
  },
};