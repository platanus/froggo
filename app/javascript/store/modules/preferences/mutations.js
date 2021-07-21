import {
  SET_ORGANIZATION,
  SET_TEAM,
  SET_TIMESPAN,
  SET_FETCHING_DEFAULT_PREFERENCES,
} from '../../mutation-types';

export default {
  [SET_ORGANIZATION](state, organization) {
    state.organization = organization;
  },
  [SET_TEAM](state, team) {
    state.team = team;
  },
  [SET_TIMESPAN](state, timespan) {
    state.timespan = timespan;
  },
  [SET_FETCHING_DEFAULT_PREFERENCES](state, fetchingState) {
    state.fetchingDefaultPreferences = fetchingState;
  },
};
