import {
  USER_STATISTICS_START_FETCHING,
  USER_STATISTICS_RECEIVED,
  USER_STATISTICS_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [USER_STATISTICS_START_FETCHING](state, githubUserLogin) {
    state.mapGithubUserToStatistics = {
      ...state.mapGithubUserToStatistics,
      [githubUserLogin]: {
        ...state.mapGithubUserToStatistics[githubUserLogin],
        fetching: true,
      },
    };
  },

  [USER_STATISTICS_RECEIVED](
    state, { githubUserLogin, countObedient, countIndifferent, countRebel, countNotDefined }) {
    state.mapGithubUserToStatistics = {
      ...state.mapGithubUserToStatistics,
      [githubUserLogin]: {
        ...state.mapGithubUserToStatistics[githubUserLogin],
        fetching: false,
        obedientCount: countObedient,
        indifferentCount: countIndifferent,
        rebelCount: countRebel,
        notDefinedCount: countNotDefined,
      },
    };
  },

  [USER_STATISTICS_FETCH_ERROR](state, { githubUserLogin, error }) {
    state.mapGithubUserToStatistics = {
      ...state.mapGithubUserToStatistics,
      [githubUserLogin]: {
        ...state.mapGithubUserToStatistics[githubUserLogin],
        fetching: false,
        error,
      },
    };
  },
};
