<template>
  <div class="profile__rectangle
              profile__rectangle--statistics">
    <div v-if="userStatistics.fetching" class="loading-icon">
    </div>
    <profile-statistics
      v-else
      container-class="profile__scores"
      :obedient-count="userStatistics.obedientCount"
      :indifferent-count="userStatistics.indifferentCount"
      :rebel-count="userStatistics.rebelCount"
      :not-defined-count="userStatistics.notDefinedCount"
    >
    </profile-statistics>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

import ProfileStatistics from './statistics.vue';

export default {
  props: {
    githubLogin: String,
  },
  computed: {
    ...mapGetters(['getUserStatistics']),
    userStatistics() {
      return this.getUserStatistics(this.githubLogin);
    },
  },
  components: {
    ProfileStatistics,
  },
};
</script>
