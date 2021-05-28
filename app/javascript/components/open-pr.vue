<template>
  <div class="max-w-xs p-3 mb-3 mr-3 font-medium border border-opacity-50 border-primary font-main">
    <div
      v-if="!recommendations"
      class="loading-icon"
    />
    <div
      v-else
      class="flex flex-col mb-3"
    >
      <div class="mb-3">
        {{ $i18n.t('message.profile.openPr.detection') }}
      </div>
      <div class="flex items-center justify-between mb-3">
        <div clas="mb-3">
          #{{ prTitle }}
        </div>
        <button
          class="w-6 h-full ml-1 hover"
          v-clipboard:copy="pr.htmlUrl"
          v-clipboard:success="onCopy"
          v-clipboard:error="onError"
          v-tooltip.right="getMessage()"
        >
          <img
            class="h-6 opacity-25"
            :src="require('../../assets/images/copy_button.svg').default"
          >
        </button>
      </div>

      <div class="mb-3">
        {{ $i18n.t('message.profile.openPr.assignedReviewers', { number: this.selectedReviewers.length }) }}
      </div>
      <div class="flex flex-col w-full h-24 p-3 mb-3 overflow-y-scroll">
        <a
          class="flex items-center justify-between flex-1 mb-4"
          v-for="rev in selectedReviewers"
          :key="rev.login"
        >
          <img
            class="object-cover w-8 h-8 rounded-full"
            :src="rev.avatarUrl"
          >
          <span
            class="flex-1 text-center"
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
        class="text-red-500 bg-opacity-50"
      >
        {{ $i18n.t('message.profile.openPr.error', { error: this.errors }) }}
      </p>

      <v-select
        :options="users"
        label="login"
        v-model="reviewer"
        required
        class="mb-3"
      >
        <template v-slot:no-options="{ search, searching }">
          <template v-if="searching">
            {{ $i18n.t('message.profile.openPr.assignedReviewers', { search: search }) }}
          </template>
          <template v-else>
            {{ $i18n.t('message.profile.openPr.withoutOptions') }}
          </template>
        </template>
        <template v-slot:option="option">
          <div class="flex items-center justify-between mb-4">
            <img
              class="object-cover w-8 h-8 rounded-full"
              :src="option.avatarUrl"
            >
            <span
              class="flex-1 text-center"
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
      <div class="text-center">
        <button
          class="w-1/3 text-gray-100 border-2 border-solid rounded-md cursor-pointer bg-primary border-primary heap-class"
          @click="submit()"
        >
          {{ $i18n.t('message.profile.openPr.assign') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import colorFromScore from '../helpers/color-from-score';
import pullRequestReviewersApi from '../api/pull_request_reviewers';
import showMessageMixin from '../mixins/showMessageMixin';

export default {
  mixins: [showMessageMixin],
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
      return this.pr.htmlUrl;
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
    onCopy() {
      this.showMessage(this.$i18n.t('message.profile.openPr.linkCopied'));
    },
    onError() {
      this.showMessage(this.$i18n.t('message.profile.openPr.linkCopyError'));
    },
    getMessage() {
      return this.$i18n.t('message.profile.openPr.copyLinkMessage');
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
