import { shallowMount } from '@vue/test-utils';

import openPR from '../../components/open-pr.vue';

describe('openPR', () => {
  const mockStore = {
    state: {
      profile: {
        recommendations: { all: ['user_1', 'user_2', 'user_3'] },
        fetchingRecommendations: false,
      },
    },
  };
  describe('User has 1 open PR', () => {
    it('Renders Title of open PR', () => {
      const wrapper = shallowMount(openPR, {
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
