import api from './index';

export default {
  updateRepository(repositoryId, body) {
    return api({
      method: 'put',
      url: `/api/v1/repositories/${repositoryId}`,
      data: body,
    });
  },
};
