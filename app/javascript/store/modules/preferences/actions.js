import preferencesApi from '../../../api/preferences';

import {
  LOAD_DEFAULT_PREFERENCES,
} from '../../action-types';

import {
  SET_ORGANIZATION,
  SET_TEAM,
  SET_TIMESPAN,
} from '../../mutation-types';

export default {
  async [LOAD_DEFAULT_PREFERENCES]({ commit }, userId) {
    const data = await preferencesApi.getPreferences(userId);

    const preferences = data.data.data.attributes;
    commit(SET_ORGANIZATION, preferences.defaultOrg);
    commit(SET_TEAM, preferences.defaultTeam);
    commit(SET_TIMESPAN, preferences.defaultTime);
  },
};
