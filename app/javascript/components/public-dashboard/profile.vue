<template>
  <div class="card public-dashboard-card">
    <div class="public-dashboard-card__upper-half">
      <div class="profile__picture">
        <img :src="imageUrl" />
      </div>
      <div class="profile__github-info">
        <a :href="githubUrl">
          <div class="profile__link">
            @{{ githubLogin }}
          </div>
        </a>
      </div>
    </div>
    <div v-if="userData.fetching" class="public-dashboard-card__lower-half">
      <div class="loading-icon loading-icon--flex-centered">
      </div>
    </div>
    <profile-scores
      v-else
      container-class="public-dashboard-card__lower-half"
      :score-this-week="userData.scoreThisWeek"
      :score-last-week="userData.scoreLastWeek"
    >
    </profile-scores>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

import ProfileScores from '../profile/scores.vue';

const MAX_PERCENTUAL_DIFFERENCE = 999;

export default {
  props: {
    organizationId: String,
    githubLogin: String,
    imageUrl: String,
  },
  computed: {
    githubUrl() {
      return `https://github.com/${this.githubLogin}`;
    },
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
