import api from './index';

export default {
  addReviewer(data) {
    return api({
      method: 'post',
      url: '/api/pull_request_reviewer/add',
      data,
    });
  },
};
