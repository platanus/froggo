import axios from 'axios';
import { decamelizeKeys } from 'humps';
import {
  CREATE_NEW_FROGGO_TEAM,
  UPDATE_FROGGO_TEAM,
  DELETE_FROGGO_TEAM,
} from '../../action-types';

export default {
  [CREATE_NEW_FROGGO_TEAM](_, { name, organizationId, userIds }) {
    return axios.post(
      `/api/organizations/${organizationId}/froggo_teams`, decamelizeKeys({ name, newMembersIds: userIds }));
  },

  [UPDATE_FROGGO_TEAM](_, { id, name, newMembersIds, oldMembersIds }) {
    return axios.patch(
      `/api/froggo_teams/${id}`, decamelizeKeys({ name, newMembersIds, oldMembersIds }));
  },

  [DELETE_FROGGO_TEAM](_, { id }) {
    const response = confirm('Estás seguro de querer borrar el equipo ?');
    if (response) {
      return axios.delete(`/api/froggo_teams/${id}`);
    }

    return false;
  },
};
