<template>
  <div class="pd-card">
    <div class="pd-card__upper-half">
      <div class="profile__picture">
        <img :src=imageUrl />
      </div>
      <div class="profile__github-info">
        <a :href="githubUrl">
          <div class="profile__link">
            <div class="profile__link-icon">
              icon |
            </div>
            <div>
              @{{ githubLogin }}
            </div>
          </div>
        </a>
      </div>
    </div>
    <div v-if="userData.fetching" class="pd-card__lower-half">
      <div class="loading-icon loading-icon--flex-centered">
      </div>
    </div>
    <div v-else class="pd-card__lower-half">
      <div class="pd-card__number-container">
        <div class="pd-card__number">
          {{ userData.thisWeeksScore.toFixed(0) }}
        </div>
        <div class="pd-card__text">
          puntaje esta semana
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

import { CREATE_PUBLIC_USER_ENTRY } from '../store/mutation-types';
import { COMPUTE_USERS_ORGANIZATION_WIDE_SCORE } from '../store/action-types';

export default {
  props: {
    organizationId: String,
    githubLogin: String,
    imageUrl: String,
  },
  created() {
    this.$store.commit(CREATE_PUBLIC_USER_ENTRY, this.githubLogin);
    this.$store.dispatch(
      COMPUTE_USERS_ORGANIZATION_WIDE_SCORE, {
        githubUserLogin: this.githubLogin,
        organizationId: this.organizationId,
      }
    );
  },
  computed: {
    githubUrl() {
      return `https://github.com/${this.githubLogin}`;
    },
    ...mapState({
      userData(state) {
        return state.publicDashboard.mapGithubUserToScores[this.githubLogin];
      },
    }),
  },
}
</script>
