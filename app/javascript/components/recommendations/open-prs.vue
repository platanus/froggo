<template>
  <div>
    <div
      v-if="fetchingRecommendations "
      class="text-black text-sm text-center text-opacity-50"
    >
      {{ $i18n.t('message.recommendations.loading') }}
    </div>
    <div v-else>
      <div
        v-if="!pullRequests.length"
        class="rounded border p-3 text-sm text-black text-opacity-25 text-center"
      >
        <i>{{ $i18n.t('message.recommendations.noPullRequests') }}</i>
      </div>
      <div
        v-else
        class="border rounded-t-lg grid grid-flow-row divide-y"
      >
        <div class="p-4 text-sm">
          {{ $i18n.t('message.recommendations.openPullRequests') }} ({{ pullRequests.length }})
        </div>
        <div
          v-for="pullRequest in pullRequests"
          :key="pullRequest.id"
        >
          <open-pr
            :pull-request="pullRequest"
            :recommendations="recommendations"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import openPr from './open-pr.vue';

export default {
  components: { openPr },
  props: {
    fetchingRecommendations: {
      type: Boolean,
      default: true,
    },
    recommendations: {
      type: Object,
      default: () => {},
    },
    pullRequests: {
      type: Array,
      default: () => [],
    },
  },
};
</script>

