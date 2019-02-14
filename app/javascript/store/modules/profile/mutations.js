import {
  SCORE_FETCH_ERROR,
  SCORE_RECEIVED,
  SCORE_START_FETCHING,
} from '../../mutation-types';

export default {
  [SCORE_RECEIVED](state, { score }) {
    state.score = score;
    state.scoreFetchInProgress = false;
  },

  [SCORE_START_FETCHING](state) {
    state.scoreFetchInProgress = true;
  },

  [SCORE_FETCH_ERROR](state) {
    state.scoreFetchInProgress = false;
  },
};
