<template>
  <div
    class="matrix__head"
    id="sticky-head"
  >
    <div
      class="matrix__user-head"
      v-for="(user, index) in correlationMatrix.selected_users"
      :key="user.id"
    >
      <div class="matrix__picture">
        <a
          :href="`/users/${user.id}`"
        >
          <div
            class="matrix__user-div"
            v-if="index == correlationMatrix.min_ranking_indexes[0]"
          >
            <div>
              <img
                class="matrix__user-img"
                :src="user.avatar_url"
                v-tooltip="getTooltipMessage(user, index)"
              >
            </div>
            <img
              class="matrix__user-crown"
              src="/assets/dashboard-img-crown-67e7b8e051ce7e158602beaf5d625e6ebb4e6156d56fc4266215911c87eb47df.svg"
            >
          </div>
          <img
            v-else
            :class="getClass(index)"
            :src="user.avatar_url"
            v-tooltip="getTooltipMessage(user, index)"
          >
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    correlationMatrix: {
      type: Object,
      required: true,
    },
    colorScores: {
      type: Object,
      default: null,
    },
    belongedTeam: {
      type: Boolean,
      default: false,
    },
    inactiveDays: {
      type: Object,
      default: null,
    },
  },
  methods: {
    getClass(index) {
      if (index === this.correlationMatrix.min_ranking_indexes[1]) {
        return 'matrix__user-img--second';
      } else if (index === this.correlationMatrix.min_ranking_indexes[2]) {
        return 'matrix__user-img--third';
      }

      return 'matrix__user-img';
    },
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
