import {
  TEAM_NAME,
  LOAD_MEMBERS,
  ADD_MEMBER,
  REMOVE_MEMBER,
} from '../../mutation-types';

export default {
  [TEAM_NAME](state, name) {
    state.teamName = name;
  },
  [LOAD_MEMBERS](state, { members, possibleMembers }) {
    state.currentMembers = [...members];
    state.possibleMembers = [...possibleMembers];
  },
  [ADD_MEMBER](state, member) {
    state.currentMembers = [...state.currentMembers, member];
    const index = state.possibleMembers.findIndex(user => user.id === member.id);
    state.possibleMembers.splice(index, 1);
  },
  [REMOVE_MEMBER](state, { index, member }) {
    state.currentMembers.splice(index, 1);
    state.possibleMembers = [...state.possibleMembers, member];
  },
};
