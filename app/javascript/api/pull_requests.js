import api from './index';

export default {
  addLike(prId) {
    return api({
      method: 'post',
      url: `/api/v1/pull_requests/${prId}/likes`,
    });
  },
  deleteLike(prId, userLikeId) {
    return api({
      method: 'delete',
      url: `/api/v1/pull_requests/${prId}/likes/${userLikeId}`,
    });
  },
};
