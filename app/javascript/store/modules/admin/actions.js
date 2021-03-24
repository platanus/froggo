import organizationsApi from '../../../api/organizations';

import {
  UPDATE_DEFAULT_TEAM,
} from '../../action-types';

export default {
  [UPDATE_DEFAULT_TEAM](_, { teamId, organization, froggoTeam }) {
    organizationsApi.update(organization.id, {
      'default_team_id': teamId,
      'froggo_team': froggoTeam,
    });
  },
};
