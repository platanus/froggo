import api from './index';

export default {
  updateRepository(repositoryId, body) {
    return api({
      method: 'put',
      url: `/api/repositories/${repositoryId}`,
      data: body,
    });
  },
};
