import axios from 'axios';
import { decamelizeKeys } from 'humps';

import {
  COMPUTE_STATISTICS,
  COMPUTE_RECOMMENDATIONS,
  PROCESS_NEW_TEAM,
  COMPUTE_PROFILE_PR_INFORMATION,
} from '../../action-types';

import {
  PROFILE_TEAM_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
  START_FETCHING_PR_INFORMATION,
  PROFILE_PR_INFORMATION_RECEIVED,
  PROFILE_PR_INFORMATION_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [PROCESS_NEW_TEAM](
    { commit, dispatch }, { teamId, organizationId, githubUserLogin }) {
    commit(PROFILE_TEAM_SELECTED, teamId);
    dispatch(COMPUTE_STATISTICS, {
      organizationId,
      githubUserLogin,
    });
    dispatch(COMPUTE_RECOMMENDATIONS, { teamId, githubUserLogin });
    dispatch(COMPUTE_PROFILE_PR_INFORMATION, { githubUserLogin });
  },

  [COMPUTE_RECOMMENDATIONS]({ commit }, { teamId, githubUserLogin, monthLimit }) {
    commit(START_FETCHING_RECOMMENDATIONS);
    axios
      .get(`/api/teams/${teamId}/users/${githubUserLogin}/recommendations`, {
        params: decamelizeKeys({
          monthLimit,
        }),
      })
      .then(response => {
        commit(RECOMMENDATIONS_RECEIVED, response.data.response.recommendations);
      })
      .catch(error => {
        commit(RECOMMENDATIONS_FETCH_ERROR, error);
      });
  },

  [COMPUTE_PROFILE_PR_INFORMATION]({ commit }, { githubUserLogin, monthLimit }) {
    commit(START_FETCHING_PR_INFORMATION);
    axios
      .get(`/api/users/${githubUserLogin}/pull_requests_information`, {
        params: decamelizeKeys({
          monthLimit,
        }),
      })
      .then(response => {
        commit(PROFILE_PR_INFORMATION_RECEIVED, response.data.response.metrics);
      })
      .catch(error => {
        commit(PROFILE_PR_INFORMATION_FETCH_ERROR, error);
      });
  },
};
