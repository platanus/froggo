import axios from 'axios';
import { decamelizeKeys } from 'humps';

export default {
  addReviewer(data) {
    return axios.post(
      '/api/pull_request_reviewer/add',
      decamelizeKeys(data),
    );
  },
};
