import {
  TEAM_NAME,
} from '../../mutation-types';

export default {
  [TEAM_NAME](state, name) {
    state.teamName = name;
  },
};
