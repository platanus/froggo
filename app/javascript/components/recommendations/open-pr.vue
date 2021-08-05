<template>
  <div class="grid grid-cols-12 p-3">
    <div class="col-span-4 flex flex-col justify-around pl-2">
      <div class="text-sm font-bold flex items-center">
        <inline-svg
          :src="require('assets/images/pull-request.svg').default"
          class="text-back fill-current h-6 w-6  mr-2"
        />
        {{ pullRequest.pull_request.title }}
        <button
          class="ml-2"
          @click="copyPrUrl()"
        >
          <inline-svg
            :src="require(`assets/images/${ copied ? 'check' : 'content-copy'}.svg`).default"
            class="w-4 h-4 fill-current"
          />
        </button>
      </div>
      <div class="text-sm text-gray-500">
        {{ prDate(pullRequest.pull_request.created_at) }}
      </div>
    </div>
    <div class="col-span-2 flex flex-row items-center justify-end ml-3 text-sm">
      <div
        v-if="!pullRequest.reviewers.length"
      >
        <i>{{ $i18n.t('message.recommendations.noReviewers') }}</i>
      </div>
      <div
        v-else
        v-for="reviewer in reviewers"
        :key="reviewer.id"
        class="relative ml-2 py-0"
      >
        <img
          :class="`h-8 w-8 rounded-full shadow`"
          :src="reviewer.avatar_url"
        >
        <a
          class="absolute h-full w-full top-0 z-10"
          :href="`/users/${reviewer.id}`"
        />
      </div>
    </div>
    <div class="col-span-6 p-3">
      <multiselect-reviewer
        :reviewers="avalaibleReviewers(recommendations.all, reviewers)"
        :pull-request="pullRequest.pull_request"
        @newReviewer="appendReviewer"
      />
    </div>
  </div>
</template>
<script>

import moment from 'moment';
import multiselectReviewer from './multiselect-reviewer.vue';

const COPY_TIMEOUT_IN_MS = 3000;

export default {
  components: { multiselectReviewer },
  props: {
    pullRequest: {
      type: Object,
      default: () => {},
    },
    recommendations: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      copied: false,
      currentTimeout: null,
      reviewers: this.pullRequest.reviewers,
    };
  },
  methods: {
    clearCopyTimeout() {
      if (this.currentTimeout) {
        clearTimeout(this.currentTimeout);
      }
    },
    setCopyTimeout() {
      this.copied = true;
      this.currentTimeout = setTimeout(() => {
        this.copied = false;
      }, COPY_TIMEOUT_IN_MS);
    },
    async copyPrUrl() {
      this.clearCopyTimeout();
      this.setCopyTimeout();
      await navigator.clipboard.writeText(this.pullRequest.pull_request.html_url);
    },
    prDate(date) {
      return moment(date).locale(this.$i18n.locale).fromNow();
    },
    avalaibleReviewers(teamMembers, reviewers) {
      return teamMembers.filter((element) =>
        !reviewers.some((reviewer) => reviewer.id === element.id),
      );
    },
    appendReviewer(reviewer) {
      this.reviewers.push(this.recommendations.all.find(item => item.id === parseInt(reviewer, 10)));
    },
  },
};
</script>
