import {
  PROFILE_TEAM_SELECTED,
  PROFILE_ORGANIZATION_SELECTED,
  RECOMMENDATIONS_FETCH_ERROR,
  RECOMMENDATIONS_RECEIVED,
  START_FETCHING_RECOMMENDATIONS,
  ORGANIZATION_TEAMS_RECEIVED,
  SELECTED_TEAM_INDEX,
  SELECTED_ORGANIZATION_INDEX,
} from '../../mutation-types';

export default {
  [PROFILE_TEAM_SELECTED](state, teamId) {
    state.selectedTeamId = teamId;
  },

  [PROFILE_ORGANIZATION_SELECTED](state, organizationId){
    state.selectedOrganizationId = organizationId;
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

  [ORGANIZATION_TEAMS_RECEIVED](state, teams) {
    state.organizationTeams = teams;
  },
};
