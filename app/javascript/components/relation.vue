<template>
  <div class="relative">
    <div
      :class="`absolute z-10 w-3 h-3 right-0 rounded-full ${colorFromScore(user.score)}`"
    />
    <img
      :class="`h-8 w-8 rounded-full shadow`"
      :src="user.avatarUrl"
    >
    <a
      class="absolute h-full w-full top-0 z-20"
      :href="`/users/${user.id}`"
      v-tooltip.right="getTooltipMessage(user)"
    />
  </div>
</template>

<script>

import colorFromScore from '../helpers/tailwind-color-from-score.js';

const SCORE_PRECISION = 2;

export default {
  props: {
    user: {
      type: Object,
      default: () => { },
      required: true,
    },
  },
  methods: {
    colorFromScore,
    getTooltipMessage(user) {
      const score = user.score.toPrecision(SCORE_PRECISION);
      let lastReviewFormat = '-';
      const lastReviewDate = new Date(user.lastReview);
      if (lastReviewDate.getTime()) {
        lastReviewFormat = lastReviewDate.toLocaleDateString('es-CL', { dateStyle: 'short' });
      }

      return `${user.login}\n Puntaje: ${score}\n Última revisión:\n ${lastReviewFormat}`;
    },
  },
};
</script>
