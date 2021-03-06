import usersApi from '../../../api/users';

import {
  COMPUTE_RECOMMENDATIONS,
  PROCESS_NEW_TEAM,
  COMPUTE_PROFILE_PR_INFORMATION,
} from '../../action-types';

import {
  PROFILE_TEAM_SELECTED,
  PROFILE_ORGANIZATION_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
  START_FETCHING_PR_INFORMATION,
  PROFILE_PR_INFORMATION_RECEIVED,
  PROFILE_PR_INFORMATION_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [PROCESS_NEW_TEAM](
    { commit, dispatch }, { teamId, organizationId, githubUserLogin, froggoTeam, monthLimit }) {
    commit(PROFILE_ORGANIZATION_SELECTED, organizationId);
    commit(PROFILE_TEAM_SELECTED, { teamId, froggoTeam });
    dispatch(COMPUTE_RECOMMENDATIONS, { teamId, githubUserLogin, froggoTeam, monthLimit });
    dispatch(COMPUTE_PROFILE_PR_INFORMATION, { githubUserLogin });
  },

  [COMPUTE_RECOMMENDATIONS]({ commit }, { teamId, githubUserLogin, monthLimit, froggoTeam }) {
    commit(START_FETCHING_RECOMMENDATIONS);
    const params = { monthLimit, froggoTeam };
    usersApi.getUserRecommendations(teamId, githubUserLogin, params)
      .then(response => {
        commit(RECOMMENDATIONS_RECEIVED, response.data.response.recommendations);
      })
      .catch(error => {
        commit(RECOMMENDATIONS_FETCH_ERROR, error);
      });
  },

  [COMPUTE_PROFILE_PR_INFORMATION]({ commit }, { githubUserLogin, monthLimit }) {
    commit(START_FETCHING_PR_INFORMATION);
    usersApi.pullRequestsInformation(githubUserLogin, monthLimit)
      .then(response => {
        commit(PROFILE_PR_INFORMATION_RECEIVED, response.data.response.metrics);
      })
      .catch(error => {
        commit(PROFILE_PR_INFORMATION_FETCH_ERROR, error);
      });
  },
};
