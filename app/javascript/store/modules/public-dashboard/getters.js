import { DEFAULT_USER_DATA } from './state';

export default {
  _userData: state => githubUserLogin =>
    state.mapGithubUserToScores[githubUserLogin] || DEFAULT_USER_DATA,
};
