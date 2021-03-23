import froggoTeamsApi from '../../../api/froggo_teams';
import usersApi from '../../../api/users';

import {
  CREATE_NEW_FROGGO_TEAM,
  UPDATE_FROGGO_TEAM,
  DELETE_FROGGO_TEAM,
  COMPUTE_TEAM_PR_INFORMATION,
} from '../../action-types';

import {
  START_FETCHING_TEAM_PR_INFORMATION,
  TEAM_PR_INFORMATION_RECEIVED,
  TEAM_PR_INFORMATION_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [CREATE_NEW_FROGGO_TEAM](_, { name, organizationId, userIds }) {
    froggoTeamsApi.createFroggoTeam(organizationId, {
      name,
      newMembersIds: userIds,
    });
  },

  [UPDATE_FROGGO_TEAM](_, { id, name, newMembersIds, oldMembersIds, changedMembersIds, changedPercentages }) {
    froggoTeamsApi.updateFroggoTeam(id, {
      name,
      newMembersIds,
      oldMembersIds,
      changedMembersIds,
      changedPercentages,
    });
  },

  [DELETE_FROGGO_TEAM](_, { id }) {
    const response = confirm('Estás seguro de querer borrar el equipo ?');
    if (response) {
      froggoTeamsApi.deleteFroggoTeam(id);
    }

    return false;
  },

  [COMPUTE_TEAM_PR_INFORMATION]({ commit }, { githubUsers, monthLimit }) {
    commit(START_FETCHING_TEAM_PR_INFORMATION);
    let pullRequestsInformation = {};
    const promises = [];
    githubUsers.forEach((user) => {
      promises.push(usersApi.pullRequestsInformation(user.login, monthLimit));
    });
    Promise.all(promises)
      .then(responses => {
        responses.forEach(response => {
          pullRequestsInformation = {
            ...pullRequestsInformation,
            ...response.data.response.metrics.pull_requests_information,
          };
        });
        commit(TEAM_PR_INFORMATION_RECEIVED, pullRequestsInformation);
      })
      .catch(error => {
        commit(TEAM_PR_INFORMATION_FETCH_ERROR, error);
      });
  },
};
