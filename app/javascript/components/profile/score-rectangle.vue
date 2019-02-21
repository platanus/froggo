<template>
  <div class="profile__rectangle
              profile__rectangle--small
              profile__rectangle--padded">
    <div v-if="userData.fetching" class="loading-icon">
    </div>
    <profile-scores
      v-else
      container-class="profile__scores"
      :score-this-week="userData.scoreThisWeek"
      :score-last-week="userData.scoreLastWeek"
    >
    </profile-scores>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

import ProfileScores from './scores.vue';

export default {
  props: {
    githubLogin: String,
  },
  computed: {
    ...mapGetters(['_userData']),
    userData() {
      return this._userData(this.githubLogin);
    },
  },
  components: {
    ProfileScores,
  },
};
</script>

