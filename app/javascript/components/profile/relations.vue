<template>
  <div class="profile-relations">
    <div class="profile-relations__title">
      {{ $i18n.t('message.profile.relationsTitle') }}
    </div>
    <div class="profile-relations-users">
      <div
        v-if="beingFetched || !recommendations"
        class="loading-icon"
      />
      <vue-horizontal-list
        v-else
        :items="allRelationsBadges(recommendations['all'])"
        :options="horizontalListOptions"
      >
        <template v-slot:default="{item}">
          <a
            class="profile-relations__user"
            :key="item.id"
            :href="userURL(item.id)"
          >
            <div class="profile-relations__badged-picture">
              <div
                v-if="item.explainer"
                v-tooltip="hoverExplainers[userId2HoverIndex(item.id)]"
                :class="badgeType(item)"
              />
              <div
                v-else
                :class="badgeType(item)"
              />
              <img
                v-if="!item.explainer"
                class="profile-relations__picture"
                :src="item.avatar_url"
              >
            </div>
          </a>
        </template>
      </vue-horizontal-list>
    </div>
  </div>
</template>

<script>
import colorFromScore from '../../helpers/color-from-score';

export default {
  data() {
    return {
      hoverExplainers: [
        { content: this.$i18n.t('message.profile.badgeExplainer.low'), placement: 'bottom' },
        { content: this.$i18n.t('message.profile.badgeExplainer.midlow'), placement: 'bottom' },
        { content: this.$i18n.t('message.profile.badgeExplainer.good'), placement: 'bottom' },
        { content: this.$i18n.t('message.profile.badgeExplainer.midhigh'), placement: 'bottom' },
        { content: this.$i18n.t('message.profile.badgeExplainer.high'), placement: 'bottom' },
      ],
      horizontalListOptions: {
        responsive: [
          { size: 16 },
        ],
      },
    };
  },
  props: {
    recommendations: {
      type: Object,
      default: () => { },
    },
    beingFetched: {
      type: Boolean,
      default: true,
    },
  },
  methods: {
    colorFromScore,
    allRelationsBadges(recommendations) {
      const result = [];
      const explainers = [
        { explainer: true, score: 0.25, id: -1 },
        { explainer: true, score: 0.5, id: -2 },
        { explainer: true, score: 1, id: -3 },
        { explainer: true, score: 1.50001, id: -4 },
        { explainer: true, score: 1.75001, id: -5 },
      ];
      recommendations.forEach((item) => {
        const user = item[1];
        while (explainers.length && user.score > explainers[0].score) {
          result.push(explainers.shift());
        }
        user.explainer = false;
        result.push(user);
      });
      while (explainers.length) result.push(explainers.shift());

      return result;
    },
    userURL(userId) {
      if (userId < 0) return '#';

      return `/users/${userId}`;
    },
    badgeType(user) {
      if (user.explainer) {
        const baseClass = 'profile-relations__badge-explainer';

        return `${baseClass} ${baseClass}--${this.colorFromScore(user.score)}`;
      }

      return `profile-relations__color-badge profile-relations__color-badge--${this.colorFromScore(user.score)}`;
    },
    userId2HoverIndex(userId) {
      if (userId >= 0) return 0;

      return Math.abs(userId + 1);
    },
  },
};
</script>
