<template>
  <div class="pd-card">
    <div class="pd-card__upper-half">
      <div class="profile__picture">
        <img :src=imageUrl />
      </div>
      <div class="profile__github-info">
        <a :href="githubUrl">
          <div class="profile__link">
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
          {{ userData.scoreThisWeek.toFixed(0) }}
        </div>
        <div class="pd-card__text">
          puntaje esta semana
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex';

import { COMPUTE_USERS_ORGANIZATION_WIDE_SCORE } from '../../store/action-types';
import { DEFAULT_USER_DATA } from '../../store/modules/public-dashboard/state';

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
