<template>
  <div class="profile__score">
    <div class="loading-icon" v-if="scoreFetchInProgress">
    </div>
    <div v-else>
      {{ score.toFixed(1) }}
    </div>
  </div>
</template>

<script>

import { mapState } from 'vuex';

export default {
  computed: mapState({
    score: state => state.profile.score,
    scoreFetchInProgress: state => state.profile.scoreFetchInProgress,
  }),
};
</script>

