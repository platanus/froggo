<template>
  <div v-if="!noTeamsInOrganization">
    <div class="grid grid-cols-2 gap-4">
      <team-table
        :fetching-recommendations="fetchingRecommendations"
        :recommendations="recommendations"
        color="teal-500"
        type="best"
        :title="$i18n.t('message.recommendations.recommendedReviewers')"
      />
      <team-table
        :fetching-recommendations="fetchingRecommendations"
        :recommendations="recommendations"
        color="red-500"
        type="worst"
        :title="$i18n.t('message.recommendations.notRecommendedReviewers')"
      />
    </div>
    <div class="w-3/4 mx-auto my-6">
      <team-relations
        :fetching-recommendations="fetchingRecommendations"
        :recommendations="recommendations"
      />
    </div>
    <open-prs
      :fetching-recommendations="fetchingRecommendations"
      :recommendations="recommendations"
      :pull-requests="pullRequests"
    />
  </div>
  <div
    v-else
    class="rounded border p-3 text-sm text-black text-opacity-25 text-center mt-5"
  >
    {{ $i18n.t('message.recommendations.noTeamsInOrganization') }}
  </div>
</template>

<script>

import { mapState } from 'vuex';

import TeamTable from './team-table.vue';
import TeamRelations from './team-relations.vue';
import OpenPrs from './open-prs.vue';

export default {
  props: {
    pullRequests: {
      type: Array,
      default: () => [],
    },
  },
  components: {
    TeamTable,
    TeamRelations,
    OpenPrs,
  },
  computed: mapState({
    recommendations: state => state.recommendations.recommendations,
    fetchingRecommendations: state => state.recommendations.fetchingRecommendations,
    noTeamsInOrganization: state => state.recommendations.noTeamsInOrganization,
  }),
};
</script>
