import axios from 'axios';
import { decamelizeKeys } from 'humps';

import {
  COMPUTE_STATISTICS,
  COMPUTE_RECOMMENDATIONS,
  PROCESS_NEW_TEAM,
} from '../../action-types';

import {
  PROFILE_TEAM_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
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
};
