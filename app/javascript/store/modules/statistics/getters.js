import { DEFAULT_USER_DATA } from './state';

export default {
  getUserStatistics: state => githubUserLogin =>
    state.mapGithubUserToStatistics[githubUserLogin] || DEFAULT_USER_DATA,
};
