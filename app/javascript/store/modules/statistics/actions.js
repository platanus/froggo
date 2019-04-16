import axios from 'axios';

import {
  USER_STATISTICS_RECEIVED,
  USER_STATISTICS_START_FETCHING,
  USER_STATISTICS_FETCH_ERROR,
} from '../../mutation-types';
import { COMPUTE_STATISTICS } from '../../action-types';

export default {
  [COMPUTE_STATISTICS](
    { commit }, { githubUserLogin, organizationId }) {
    commit(USER_STATISTICS_START_FETCHING, githubUserLogin);
    axios
      .get(`/api/organizations/${organizationId}/users/${githubUserLogin}/statistics`)
      .then(response => {
        commit(
          USER_STATISTICS_RECEIVED, {
            githubUserLogin,
            countObedient: response.data.response.statistics.obedient,
            countIndifferent: response.data.response.statistics.indifferent,
            countRebel: response.data.response.statistics.rebel,
            countNotDefined: response.data.response.statistics.not_defined,
          });
      })
      .catch(error => {
        console.log(error);
        commit(USER_STATISTICS_FETCH_ERROR, { githubUserLogin, error });
      });
  },
};
