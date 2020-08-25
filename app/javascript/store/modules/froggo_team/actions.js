import axios from 'axios';
import * as humps from 'humps';

import {
  CREATE_NEW_FROGGO_TEAM,
} from '../../action-types';

export default {
  [CREATE_NEW_FROGGO_TEAM](_, { name, organizationId, users }) {
    axios.post(
      `/api/organizations/${organizationId}/froggo_teams`,
      { name },
      { headers: { 'Content-Type': 'application/json' } },
    )
      .then(async (response) => {
        const { data: { id } } = response;

        return Promise.all(users.map(user => axios.post(`/api/froggo_teams/${id}/add_member`,
          humps.decamelizeKeys({ githubLogin: user.login }))));
      })
      .then(() => alert('se creó el grupo correctamente'))
      .catch(() => { alert('no se pudo crear el grupo correctamente'); });
  },
};
