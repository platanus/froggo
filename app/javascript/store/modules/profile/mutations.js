import * as types from './mutation_types';

export default {
  [types.SCORE_RECEIVED](state, payload) {
    state.score = payload.score;
  }
}
