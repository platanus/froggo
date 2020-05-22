import { DEFAULT_USER_DATA } from './state';

export default {
  getUserData: state => githubUserLogin =>
    state.mapGithubUserToScores[githubUserLogin] || DEFAULT_USER_DATA,
};
