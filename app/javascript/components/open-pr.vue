<template>
  <div class="profile-prs__container">
    <div
      v-if="!recommendations"
      class="loading-icon"
    />
    <div v-else>
      <h4>
        Se ha detectado un PR tuyo con nombre:
      </h4>
      <h3>
        #{{ prTitle }}
      </h3>

      <p
        v-if="error"
        class="profile-prs__error"
      >
        Error: {{ this.errors }}
      </p>

      <v-select
        :options="users"
        label="login"
        v-model="reviewer"
        required
      >
        <template v-slot:no-options="{ search, searching }">
          <template v-if="searching">
            No hay coincidencias para <em>{{ search }}</em>.
          </template>
        </template>
        <template v-slot:option="option">
          <div class="select-reviewer__container">
            <img
              class="select-reviewer__picture"
              :src="option.avatar_url"
            >
            <span
              class="select-reviewer__username"
            >
              {{ option.login }}
            </span>
            <div
              :class="`select-reviewer__color-badge
                select-reviewer__color-badge--${colorFromScore(option.score)}`"
            />
          </div>
        </template>
      </v-select>
      <div class="centered">
        <button
          class="profile-prs__button"
          @click="submit()"
        >
          Asignar
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import colorFromScore from '../helpers/color-from-score';
import pullRequestReviewersApi from '../api/pull_request_reviewers';

export default {
  computed: {
    ...mapState({
      recommendations: state => state.profile.recommendations,
      fetchingRecommendations: state => state.profile.fetchingRecommendations,
    }),
    users() {
      return this.recommendations.all;
    },
    prTitle() {
      return this.pr.title;
    },
    prId() {
      return this.pr.id;
    },
  },
  props: {
    pr: {
      type: Object,
      required: true,
    },
  },
  methods: {
    colorFromScore,
    submit() {
      if (this.reviewer) {
        this.addReviewer();
      } else {
        this.error = true;
        this.errors = 'Debe seleccionar algún revisor';
      }
    },
    addReviewer() {
      const data = { reviewer: this.reviewer.login, pullRequestId: this.prId };
      pullRequestReviewersApi.addReviewer(data)
        .then(() => {
          this.error = false;
          this.reviewer = '';
        }).catch(() => {
          this.error = true;
          this.errors = 'Hubo un problema ><';
          this.reviewer = '';
        });
    },
  },
  data() {
    return {
      pullRequestId: this.prId,
      reviewer: '',
      error: false,
      errors: '',
    };
  },
};
</script>
