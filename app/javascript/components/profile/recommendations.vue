<template>
  <div class="profile-interactions">
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
</template>

<script>
import { mapState } from 'vuex';

export default {
  computed: mapState({
    recommendations: state => state.profile.recommendations,
    fetchingRecommendations: state => state.profile.fetchingRecommendations,
  }),
};
</script>
