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
    <div v-else class="public-dashboard-card__lower-half">
      <div class="public-dashboard-card__number-container">
        <div class="public-dashboard-card__number">
          {{ userData.scoreThisWeek.toFixed(0) }}
        </div>
        <div class="public-dashboard-card__text">
          puntaje esta semana
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

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
};
</script>
