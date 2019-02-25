import {
  PROFILE_TEAM_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
} from '../../mutation-types';

export default {
  [PROFILE_TEAM_SELECTED](state, teamId) {
    state.selectedTeamId = teamId;
  },

  [START_FETCHING_RECOMMENDATIONS](state) {
    state.fetchingRecommendations = true;
  },

  [RECOMMENDATIONS_RECEIVED](state, recommendations) {
    state.recommendations = recommendations;
    state.fetchingRecommendations = false;
  },

  [RECOMMENDATIONS_FETCH_ERROR](state, error) {
    state.recommendationsError = error;
    state.fetchingRecommendations = false;
  },
};
