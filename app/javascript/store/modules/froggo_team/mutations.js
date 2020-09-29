import {
  TEAM_NAME,
  LOAD_MEMBERS,
  ADD_MEMBER,
  REMOVE_MEMBER,
  START_FETCHING_TEAM_PR_INFORMATION,
  TEAM_PR_INFORMATION_RECEIVED,
  TEAM_PR_INFORMATION_FETCH_ERROR,
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
  [START_FETCHING_TEAM_PR_INFORMATION](state) {
    state.fetchingPullRequestInformation = true;
  },
  [TEAM_PR_INFORMATION_RECEIVED](state, pullRequestData) {
    state.pullRequestInformation = pullRequestData;
    state.fetchingPullRequestInformation = false;
  },
  [TEAM_PR_INFORMATION_FETCH_ERROR](state, error) {
    state.prInformationError = error;
    state.fetchingPullRequestInformation = false;
  },
};
