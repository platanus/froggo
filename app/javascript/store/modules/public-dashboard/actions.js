import axios from 'axios';
import moment from 'moment';

import {
  PUBLIC_USER_SCORE_RECEIVED,
  PUBLIC_USER_SCORE_START_FETCHING,
  PUBLIC_USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';
import { COMPUTE_USERS_ORGANIZATION_WIDE_SCORE } from '../../action-types';

function computeScore(organizationId, githubUserLogin, fromDate, toDate) {
  return axios.get(`/api/organizations/${organizationId}
/users/${githubUserLogin}/score?from=${fromDate}&to=${toDate}`);
}

export default {
  [COMPUTE_USERS_ORGANIZATION_WIDE_SCORE](
    { commit }, { githubUserLogin, organizationId }) {
    const computeScoreForDates =
      computeScore.bind(this, organizationId, githubUserLogin);
    const today = moment().toISOString();
    const oneWeekAgo = moment().subtract(1, 'week').toISOString();
    // eslint-disable-next-line no-magic-numbers
    const twoWeeksAgo = moment().subtract(2, 'weeks').toISOString();
    commit(PUBLIC_USER_SCORE_START_FETCHING, githubUserLogin);
    Promise
      .all([
        computeScoreForDates(oneWeekAgo, today),
        computeScoreForDates(twoWeeksAgo, oneWeekAgo),
      ])
      .then(responses => {
        commit(
          PUBLIC_USER_SCORE_RECEIVED, {
            githubUserLogin,
            thisWeeksScore: responses[0].data.response.score,
            lastWeeksScore: responses[1].data.response.score,
          });
      })
      .catch(error => {
        commit(PUBLIC_USER_SCORE_FETCH_ERROR, { githubUserLogin, error });
      });
  },
};
