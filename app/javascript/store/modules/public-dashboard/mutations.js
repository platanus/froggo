import {
  PUBLIC_USER_SCORE_START_FETCHING,
  PUBLIC_USER_SCORE_RECEIVED,
  PUBLIC_USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';

export default {
  [PUBLIC_USER_SCORE_START_FETCHING](state, githubUserLogin) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        ...state.mapGithubUserToScores[githubUserLogin],
        fetching: true,
      },
    };
  },

  [PUBLIC_USER_SCORE_RECEIVED](
    state, { githubUserLogin, thisWeeksScore }) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        ...state.mapGithubUserToScores[githubUserLogin],
        fetching: false,
        scoreThisWeek: thisWeeksScore,
      },
    };
  },

  [PUBLIC_USER_SCORE_FETCH_ERROR](state, { githubUserLogin, error }) {
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
