<template>
  <div :class="`grid grid-flow-rows w-full text-${color}`">
    <div class="text-sm">
      {{ title }}
    </div>
    <div :class="`border p-3 grid grid-flow-row gap-3 border-${color}`">
      <div
        v-if="fetchingRecommendations"
        class="text-black text-sm text-center text-opacity-50"
      >
        {{ $i18n.t('message.recommendations.loading') }}
      </div>

      <a
        v-else
        class="flex items-center"
        v-for="user in recommendations[type]"
        :key="user.id"
        :href="`/users/${user.id}`"
      >
        <img
          class="h-8 w-8 rounded-full mr-3"
          :src="user.avatarUrl"
        >
        <div class="text-sm">
          {{ user.login }}
        </div>
        <div :class="`bg-${colorFromScore(user.score)} rounded-full w-5 h-5 ml-auto mr-2`" />
      </a>
    </div>
  </div>
</template>

<script>

import colorFromScore from '../../helpers/tailwind-color-from-score.js';

export default {
  props: {
    title: {
      type: String,
      required: true,
    },
    color: {
      type: String,
      default: 'gray-500',
    },
    recommendations: {
      type: Object,
      default: () => { },
    },
    type: {
      type: String,
      required: true,
    },
    fetchingRecommendations: {
      type: Boolean,
      default: true,
    },
  },
  methods: {
    colorFromScore,
  },
};
</script>
