import axios from 'axios';

import {
  PUBLIC_USER_SCORE_RECEIVED,
  PUBLIC_USER_SCORE_START_FETCHING,
  PUBLIC_USER_SCORE_FETCH_ERROR,
} from '../../mutation-types';
import { COMPUTE_USERS_ORGANIZATION_WIDE_SCORE } from '../../action-types';

export default {
  [COMPUTE_USERS_ORGANIZATION_WIDE_SCORE](
    { commit }, { githubUserLogin, organizationId }) {
    commit(PUBLIC_USER_SCORE_START_FETCHING, githubUserLogin);
    axios
      .get(`/api/organizations/${organizationId}
/users/${githubUserLogin}/score?weeks=1`)
      .then(response => {
        commit(
          PUBLIC_USER_SCORE_RECEIVED,
          { githubUserLogin, thisWeeksScore: response.data.response.score }
        );
      })
      .catch(error => {
        commit(PUBLIC_USER_SCORE_FETCH_ERROR, { githubUserLogin, error });
      });
  },
};
