import axios from 'axios';
import { decamelizeKeys } from 'humps';
import {
  CREATE_NEW_FROGGO_TEAM,
} from '../../action-types';

export default {
  [CREATE_NEW_FROGGO_TEAM](_, { name, organizationId, userIds }) {
    return axios.post(
      `/api/organizations/${organizationId}/froggo_teams`, decamelizeKeys({ name, newMembersIds: userIds }));
  },
};
