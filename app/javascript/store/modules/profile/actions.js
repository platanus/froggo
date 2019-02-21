import axios from 'axios';
import moment from 'moment';

import {
  SCORE_FETCH_ERROR,
  SCORE_RECEIVED,
  SCORE_START_FETCHING,
} from '../../mutation-types';
import { COMPUTE_SCORE } from '../../action-types';

export default {
  [COMPUTE_SCORE]({ commit }, { organizationId, teamId, githubUserLogin, weeksAgo }) {
    commit(SCORE_START_FETCHING);
    const oneWeekAgo = moment().subtract(weeksAgo, 'weeks').toISOString();
    axios.get(`/api/organizations/${organizationId}/teams/${teamId}
/users/${githubUserLogin}/score?from=${oneWeekAgo}`)
      .then(response => {
        commit(SCORE_RECEIVED, { score: response.data.response.score });
      })
      .catch(() => {
        commit(SCORE_FETCH_ERROR);
      });
  },
};
