import { shallowMount } from '@vue/test-utils';

import pendingPr from '../../components/pending-pr.vue';

describe('PendingPR', () => {
  const mockStore = {
    state: {
      profile: {
        recommendations: { all: ['user_1', 'user_2', 'user_3'] },
        fetchingRecommendations: false,
      },
    },
  };
  describe('User has 1 pending PR', () => {
    it('Renders Title of Pending PR', () => {
      const wrapper = shallowMount(pendingPr, {
        propsData: {
          pr: 'Test PR',
        },
        mocks: {
          $store: mockStore,
        },
      });
      expect(wrapper.html()).toContain('Test PR');
    });
  });
});
