import axios from 'axios';

import {
  COMPUTE_SCORES,
  COMPUTE_RECOMMENDATIONS,
  PROCESS_NEW_TEAM,
  PROCESS_NEW_ORGANIZATION,
} from '../../action-types';

import {
  PROFILE_TEAM_SELECTED,
  PROFILE_ORGANIZATION_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
  ORGANIZATION_TEAMS_RECEIVED,
} from '../../mutation-types';

export default {
  [PROCESS_NEW_TEAM](
    { commit, dispatch }, { teamId, organizationId, githubUserLogin }) {
    console.log(teamId);
    console.log(organizationId);
    commit(PROFILE_TEAM_SELECTED, teamId);
    dispatch(COMPUTE_SCORES, {
      teamId,
      organizationId,
      githubUserLogin,
    });
    dispatch(COMPUTE_RECOMMENDATIONS, { teamId, githubUserLogin });
  },

  [PROCESS_NEW_ORGANIZATION](
    { commit }, { organizationId, teams }) {
    commit(PROFILE_ORGANIZATION_SELECTED, organizationId);
    commit(
      ORGANIZATION_TEAMS_RECEIVED,
      teams.filter(team => team.organization_id === organizationId)
    );
  },

  [COMPUTE_RECOMMENDATIONS]({ commit }, { teamId, githubUserLogin }) {
    commit(START_FETCHING_RECOMMENDATIONS);
    axios
      .get(`/api/teams/${teamId}/users/${githubUserLogin}/recommendations`)
      .then(response => {
        commit(RECOMMENDATIONS_RECEIVED, response.data.response.recommendations);
      })
      .catch(error => {
        commit(RECOMMENDATIONS_FETCH_ERROR, error);
      });
  },
};
