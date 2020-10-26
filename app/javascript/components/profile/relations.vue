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
        :items="allRelationsBadges"
        :options="horizontalListOptions"
      >
        <template v-slot:default="{item}">
          <div
            v-if="item.explainer"
            class="profile-relations__user"
          >
            <div
              v-tooltip="item.tooltip"
              :class="`profile-relations__badge-explainer
                profile-relations__badge-explainer--${colorFromScore(item.score)}`"
            />
          </div>
          <template v-else>
            <a
              class="profile-relations__user"
              :key="item.id"
              :href="`/users/${item.id}`"
            >
              <div class="profile-relations__badged-picture">
                <div
                  :class="`profile-relations__color-badge
                    profile-relations__color-badge--${colorFromScore(item.score)}`"
                />
                <img
                  class="profile-relations__picture"
                  :src="item.avatar_url"
                  v-tooltip="getTooltipMessage(user, index)"
                >
              </div>
            </a>
          </template>
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
  computed: {
    allRelationsBadges() {
      const result = [];
      const explainers = [
        { explainer: true, score: 0.25,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.low'), placement: 'bottom' } },
        { explainer: true, score: 0.5,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.midlow'), placement: 'bottom' } },
        { explainer: true, score: 1,
          tooltip: { content: this.$i18n.t('message.profile.badgeExplainer.good'), placement: 'bottom' } },
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
    getTooltipMessage(user, index) {
      if (!this.belongedTeam || index === 0) {
        return user.login;
      }

      const userInfo = user.login.concat(' \n',
        this.$t('message.organization.members.inactiveDays'),
        this.inactiveDays[user.id],
        ' \n',
        this.$t('message.organization.members.score'),
        this.colorScores[user.id]);

      return userInfo;
    },
  },
};
</script>
