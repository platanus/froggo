import usersApi from '../../../api/users';

import {
  LOAD_RECOMMENDATIONS,
} from '../../action-types';

import {
  SET_RECOMMENDATIONS,
  ERROR_FETCHING_RECOMMENDATIONS,
} from '../../mutation-types';

export default {
  async [LOAD_RECOMMENDATIONS]({ commit, rootState }, githubUserLogin) {
    const limits = {
      'one_month': 1,
      'three_months': 3,
      'six_months': 6,
      'nine_months': 9,
      'twelve_months': 12,
    };

    const params = {
      'monthLimit': limits[rootState.preferences.timespan],
      'froggoTeam': true,
    };

    try {
      const data = await usersApi.getUserRecommendations(rootState.preferences.team.id, githubUserLogin, params);
      commit(SET_RECOMMENDATIONS, data.data.response.recommendations);
    } catch (error) {
      commit(ERROR_FETCHING_RECOMMENDATIONS, error);
    }
  },
};
