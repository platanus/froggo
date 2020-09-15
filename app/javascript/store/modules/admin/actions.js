import axios from 'axios';

import {
  UPDATE_DEFAULT_TEAM,
} from '../../action-types';

export default {
  [UPDATE_DEFAULT_TEAM](_, { teamId, organization, froggoTeam }) {
    axios
      .put(`/api/organizations/${organization.id}/update`, {
        'default_team_id': teamId,
        'froggo_team': froggoTeam,
      });
  },
};
