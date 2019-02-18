import {
  CREATE_PUBLIC_USER_ENTRY,
  PUBLIC_USER_SCORE_START_FETCHING,
  PUBLIC_USER_SCORE_RECEIVED,
  PUBLIC_USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';

import { defaultUserData } from './state';

export default {
  [CREATE_PUBLIC_USER_ENTRY](state, githubUserLogin) {
    state.mapGithubUserToScores = {
      ...state.mapGithubUserToScores,
      [githubUserLogin]: {
        defaultUserData,
      },
    };
  },

  [PUBLIC_USER_SCORE_START_FETCHING](state, githubUserLogin) {
    state.mapGithubUserToScores[githubUserLogin].fetching = true;
  },

  [PUBLIC_USER_SCORE_RECEIVED](
    state, { githubUserLogin, thisWeeksScore }) {
    state.mapGithubUserToScores[githubUserLogin] = {
      ...state.mapGithubUserToScores[githubUserLogin],
      fetching: false,
      thisWeeksScore,
    };
  },

  [PUBLIC_USER_SCORE_FETCH_ERROR](state, { githubUserLogin, error }) {
    state.mapGithubUserToScores[githubUserLogin] = {
      ...state.mapGithubUserToScores[githubUserLogin],
      fetching: false,
      error,
    };
  },
};
