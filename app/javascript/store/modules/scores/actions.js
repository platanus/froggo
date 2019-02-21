import axios from 'axios';
import moment from 'moment';

import {
  USER_SCORE_RECEIVED,
  USER_SCORE_START_FETCHING,
  USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';
import { COMPUTE_SCORES } from '../../action-types';

function computeOrganizationScore(organizationId, githubUserLogin, { from, to }) {
  return axios.get(`/api/organizations/${organizationId}
/users/${githubUserLogin}/score?from=${from}&to=${to}`);
}

function computeTeamScore(organizationId, githubUserLogin, teamId, { from, to }) {
  return axios.get(`/api/organizations/${organizationId}/teams/${teamId}
/users/${githubUserLogin}/score?from=${from}&to=${to}`);
}

export default {
  [COMPUTE_SCORES](
    { commit }, { githubUserLogin, organizationId, teamId }) {
    const computeScoreForDates =
      teamId ?
        computeTeamScore.bind(this, organizationId, githubUserLogin, teamId) :
        computeOrganizationScore.bind(this, organizationId, githubUserLogin);
    const today = moment().toISOString();
    const oneWeekAgo = moment().subtract(1, 'week').toISOString();
    // eslint-disable-next-line no-magic-numbers
    const twoWeeksAgo = moment().subtract(2, 'weeks').toISOString();
    commit(USER_SCORE_START_FETCHING, githubUserLogin);
    Promise
      .all([
        computeScoreForDates({ from: oneWeekAgo, to: today }),
        computeScoreForDates({ from: twoWeeksAgo, to: oneWeekAgo }),
      ])
      .then(responses => {
        commit(
          USER_SCORE_RECEIVED, {
            githubUserLogin,
            thisWeeksScore: responses[0].data.response.score,
            lastWeeksScore: responses[1].data.response.score,
          });
      })
      .catch(error => {
        commit(USER_SCORE_FETCH_ERROR, { githubUserLogin, error });
      });
  },
};
