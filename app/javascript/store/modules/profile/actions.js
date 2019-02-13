import * as types from './mutation_types';

export default {
  computeScore({ commit }, organizationId, teamSlug, userId, weeksAgo = 1) {
    commit(types.SCORE_RECEIVED, { score: 38 });
  },
};
