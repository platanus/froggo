<template>
  <div class="flex">
    <div
      v-if="fetchingRecommendations"
      class="text-black text-sm text-center text-opacity-50"
    >
      {{ $i18n.t('message.recommendations.loading') }}
    </div>
    <vue-horizontal
      v-else
    >
      <section
        v-for="element in allRelationsBadges"
        :key="element.id"
        class="mx-1 py-1"
      >
        <div
          v-if="element.explainer"
          v-tooltip="element.tooltip"
          :class="`my-auto h-5 w-5 rounded-full shadow-sm m-1 bg-${colorFromScore(element.score)}`"
        />
        <relation
          v-else
          :user="element"
        />
      </section>
    </vue-horizontal>
  </div>
</template>

<script>
import VueHorizontal from 'vue-horizontal';
import relation from '../relation.vue';
import colorFromScore from '../../helpers/tailwind-color-from-score.js';

export default {
  components: {
    VueHorizontal,
    relation,
  },
  props: {
    recommendations: {
      type: Object,
      default: () => { },
    },
    fetchingRecommendations: {
      type: Boolean,
      default: true,
    },
  },
  computed: {
    allRelationsBadges() {
      const result = [];
      const explainers = [
        { explainer: true, score: 0.25,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.low'), placement: 'bottom' } },
        { explainer: true, score: 0.5,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.midlow'), placement: 'bottom' } },
        { explainer: true, score: 0.75,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.midlow'), placement: 'bottom' } },
        { explainer: true, score: 1,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.good'), placement: 'bottom' } },
        { explainer: true, score: 1.25,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.midhigh'), placement: 'bottom' } },
        { explainer: true, score: 1.50001,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.midhigh'), placement: 'bottom' } },
        { explainer: true, score: 1.75001,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.high'), placement: 'bottom' } },
      ];
      this.recommendations.all.forEach((item) => {
        while (explainers.length && item.score > explainers[0].score) {
          result.push(explainers.shift());
        }
        item.explainer = false;
        result.push(item);
      });

      return result.concat(explainers);
    },
  },
  methods: {
    colorFromScore,
  },
};
</script>

<style lang="scss">
  svg[data-v-4eb718e5] {
    @apply bg-white fill-current h-6 w-6 #{!important};
  }
  div[data-v-4eb718e5].v-hl-container {
    @apply  items-center px-4 w-full mx-auto #{!important};
  }
  div[data-v-4eb718e5].vue-horizontal {
    @apply mx-auto #{!important};
  }

</style>

