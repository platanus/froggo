import {
  SET_FETCHING_RECOMMENDATIONS,
  ERROR_FETCHING_RECOMMENDATIONS,
  SET_RECOMMENDATIONS,
  SET_NO_ORGANIZATIONS,
  SET_NO_TEAMS_IN_ORGANIZATION,
} from '../../mutation-types';

export default {
  [SET_FETCHING_RECOMMENDATIONS](state, fetchingState) {
    state.fetchingRecommendations = fetchingState;
  },
  [SET_RECOMMENDATIONS](state, recommendations) {
    state.recommendations = recommendations;
  },
  [ERROR_FETCHING_RECOMMENDATIONS](state, error) {
    state.recommendationsError = error;
  },

  [SET_NO_ORGANIZATIONS](state, bool) {
    state.noOrganizations = bool;
  },
  [SET_NO_TEAMS_IN_ORGANIZATION](state, bool) {
    state.noTeamsInOrganization = bool;
  },
};
