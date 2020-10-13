<template>
  <div>
    <div
      class="profile-interactions"
      v-if="selectedTeam"
    >
      <profile-relations
        :being-fetched="fetchingRecommendations"
        :recommendations="recommendations"
      />
      <div class="profile-recommendations">
        <profile-recommendations-users
          :being-fetched="fetchingRecommendations"
          :recommendations="recommendations"
          type="best"
          :title="$i18n.t('message.profile.recommendedReviewers')"
        />
        <profile-recommendations-users
          :being-fetched="fetchingRecommendations"
          :recommendations="recommendations"
          type="worst"
          :title="$i18n.t('message.profile.notRecommendedReviewers')"
        />
      </div>
    </div>
    <div
      class="card__info"
      v-else
    >
      {{ $i18n.t('message.profile.noTeamsInOrganization') }}
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import ProfileRelations from './relations.vue';
import ProfileRecommendationsUsers from './recommendations-users.vue';

export default {
  computed: mapState({
    recommendations: state => state.profile.recommendations,
    fetchingRecommendations: state => state.profile.fetchingRecommendations,
    selectedTeam: state => state.profile.selectedTeamId,
  }),
  components: {
    ProfileRelations,
    ProfileRecommendationsUsers,
  },
};
</script>
