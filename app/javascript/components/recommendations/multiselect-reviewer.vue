<template>
  <div class="flex">
    <multiselect
      track-by="login"
      label="login"
      v-model="selectedReviewers"
      :options="reviewers"
      :searchable="true"
      :multiple="true"
      :close-on-select="false"
      :clear-on-select="false"
      :show-labels="false"
      placeholder="Revisores"
    >
      <template #option="props">
        <div class="flex flex-row">
          <relation
            :user="props.option"
          />
          <div class="flex flex-col ml-3 text-black item justify-between">
            <div>{{ props.option.login }}</div>
            <div
              v-if="!props.option.tags.length"
              class="mt-3 text-xs text-gray-500"
            >
              <i>{{ $i18n.t('message.recommendations.noTags') }}</i>
            </div>
            <div
              v-else
              class="flex flex-wrap h-min-12"
            >
              <div
                v-for="tag in props.option.tags"
                :key="tag.name"
              >
                <div class="div bg-blue-900 rounded-full p-3 mt-2 mr-2 text-white">
                  {{ tag.name }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
      <template #caret="{ toggle }">
        <div
          class="absolute right-0 p-2 my-auto"
          @mousedown.prevent.stop="toggle"
        >
          <inline-svg
            :src="require('../../../assets/images/chevron-down.svg').default"
            class="text-black fill-current h-6 w-6 ml-2"
          />
        </div>
      </template>
      <template #noOptions="{ toggle }">
        <div
          class="absolute right-0 p-2 my-auto"
          @mousedown.prevent.stop="toggle"
        >
          {{ $i18n.t('message.recommendations.noReviewersAvalaible') }}
        </div>
      </template>
    </multiselect>
    <button
      :class="`rounded-r-lg border-r border-t border-b p-3 text-black
      ${ selectedReviewers.length ? 'text-opacity-100' : 'text-opacity-50'}`"
      @click="sendReviewers"
    >
      {{ $i18n.t('message.recommendations.assignReviewers') }}
    </button>
  </div>
</template>
<script>

import Multiselect from 'vue-multiselect';
import relation from '../relation.vue';
import pullRequestReviewersApi from '../../api/pull_request_reviewers';

export default {
  components: {
    Multiselect,
    relation,
  },
  data() {
    return {
      selectedReviewers: [],
    };
  },
  props: {
    reviewers: {
      type: Array,
      default: () => [],
    },
    pullRequest: {
      type: Object,
      default: () => {},
    },
  },
  methods: {
    async sendReviewers() {
      await Promise.all(this.selectedReviewers.map(async (reviewer, i) => {
        const data = { reviewer: reviewer.login, pullRequestId: this.pullRequest.id };
        const params = await pullRequestReviewersApi.addReviewer(data);

        this.$emit('newReviewer', params.data.data.id);
        this.selectedReviewers[i] = null;
      }));
      this.selectedReviewers = this.selectedReviewers.filter(item => item !== null);
    },
  },
};
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<style lang="scss">
.multiselect {

  @apply rounded-l-lg py-1 border;

  &__tags {
    @apply border-0 pl-3 rounded-lg;
  }
  &__placeholder {
    @apply text-base text-black;
  }

}
</style>
