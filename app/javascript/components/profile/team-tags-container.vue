
<template>
  <div
    class="profile-team-tags-container"
    v-if="selectedTeam"
  >
    <team-tags-table
      :being-fetched="fetchingRecommendations"
      :team="recommendations['all']"
      :tags="tags"
    />
  </div>
</template>
<script>
import { mapState } from 'vuex';
import teamTagsTable from './team-tags-table.vue';

export default {
  components: { teamTagsTable },
  props: {
    tags: {
      type: Array,
      required: true,
    },
  },
  computed: mapState({
    recommendations: state => state.profile.recommendations,
    fetchingRecommendations: state => state.profile.fetchingRecommendations,
    selectedTeam: state => state.profile.selectedTeamId,
  }),
};
</script>

