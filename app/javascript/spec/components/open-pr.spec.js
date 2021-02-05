import { shallowMount } from '@vue/test-utils';
import vSelect from 'vue-select';

import openPR from '../../components/open-pr.vue';

describe('openPR', () => {
  const mockStore = {
    state: {
      profile: {
        recommendations: {
          all: [
            { login: 'user_1', score: 1, avatarUrl: '' },
            { login: 'user_2', score: 1, avatarUrl: '' },
            { login: 'user_3', score: 1, avatarUrl: '' },
          ],
        },
        fetchingRecommendations: false,
      },
    },
  };
  describe('User has 1 open PR', () => {
    it('Renders Title of open PR', () => {
      const wrapper = shallowMount(openPR, {
        components: { vSelect },
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
