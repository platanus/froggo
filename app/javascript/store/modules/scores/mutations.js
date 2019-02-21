import {
  USER_SCORE_START_FETCHING,
  USER_SCORE_RECEIVED,
  USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [USER_SCORE_START_FETCHING](state, githubUserLogin) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        ...state.mapGithubUserToScores[githubUserLogin],
        fetching: true,
      },
    };
  },

  [USER_SCORE_RECEIVED](
    state, { githubUserLogin, thisWeeksScore, lastWeeksScore }) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        ...state.mapGithubUserToScores[githubUserLogin],
        fetching: false,
        scoreThisWeek: thisWeeksScore,
        scoreLastWeek: lastWeeksScore,
      },
    };
  },

  [USER_SCORE_FETCH_ERROR](state, { githubUserLogin, error }) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        ...state.mapGithubUserToScores[githubUserLogin],
        fetching: false,
        error,
      },
    };
  },
};
