import api from './index';

export default {
  addLike(prId) {
    return api({
      method: 'post',
      url: `/api/pull_requests/${prId}/likes`,
    });
  },
  deleteLike(prId, userLikeId) {
    return api({
      method: 'delete',
      url: `/api/pull_requests/${prId}/likes/${userLikeId}`,
    });
  },
};
