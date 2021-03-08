<template>
  <div>
    <div
      v-if="!recommendations"
      class="loading-icon"
    />
    <div
      v-else
      class="profile-prs__container"
    >
      <h4>
        Se ha detectado un PR tuyo con nombre:
      </h4>
      <h3>
        #{{ prTitle }}
      </h3>

      <h4>
        Revisores asignados ({{ this.selectedReviewers.length }}):
      </h4>
      <div class="open-pr__reviewers-container">
        <a
          class="profile-recommendations-users__user"
          v-for="rev in selectedReviewers"
          :key="rev.login"
        >
          <img
            class="select-reviewer__picture"
            :src="rev.avatar_url"
          >
          <span
            class="select-reviewer__username"
          >
            {{ rev.login }}
          </span>
          <div
            :class="`select-reviewer__color-badge
              select-reviewer__color-badge--${colorFromScore(rev.score)}`"
          />
        </a>
      </div>

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
          <template v-else>
            No hay opciones :(
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
      return this.inFirstOnly(this.recommendations.all, this.selectedReviewers);
    },
    prTitle() {
      return this.pr.title;
    },
    prId() {
      return this.pr.id;
    },
    prHref() {
      return this.pr.html_url;
    },
  },
  props: {
    pr: {
      type: Object,
      required: true,
    },
    reviewers: {
      type: Array,
      required: true,
    },
  },
  methods: {
    colorFromScore,
    inFirstOnly(firstList, secondList) {
      return firstList.filter((element) =>
        !secondList.some((secondListElement) => secondListElement.id === element.id),
      );
    },
    submit() {
      if (this.reviewer) {
        this.addReviewer();
      } else {
        this.error = true;
        this.errors = 'Debe seleccionar algún revisor';
      }
    },
    addLocalReviewer(reviewer) {
      if (!this.selectedReviewers.some(
        (selectedReviewer) => selectedReviewer.id === reviewer.id)
      ) {
        this.selectedReviewers.push(reviewer);
      }
    },
    addReviewer() {
      const data = { reviewer: this.reviewer.login, pullRequestId: this.prId };
      pullRequestReviewersApi.addReviewer(data)
        .then((params) => {
          this.error = false;
          this.reviewer = '';
          this.addLocalReviewer(params.data);
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
      selectedReviewers: this.reviewers,
    };
  },
};
</script>
