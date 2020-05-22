<template>
  <div class="profile-statistics">
    <div v-if="userStatistics.fetching" class="loading-icon">
    </div>
    <number
      v-else
      v-for="count in counts" :key="count"
      :value="userStatistics[count]"
      :text="$i18n.t(`message.profile.statistics.${count}`)" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

import Number from './number.vue';

export default {
  props: {
    githubLogin: String,
  },
  data() {
    return {
      counts: ['obedientCount', 'indifferentCount', 'rebelCount'],
    };
  },
  computed: {
    ...mapGetters(['getUserStatistics']),
    userStatistics() {
      return this.getUserStatistics(this.githubLogin);
    },
  },
  components: {
    Number,
  },
};
</script>
