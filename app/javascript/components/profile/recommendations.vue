<template>
  <div class="profile-recommendations">
    <users-rectangle
      :being-fetched="fetchingRecommendations"
      :recommendations="recommendations"
      type="best"
      :title="$i18n.t('message.profile.recommendedReviewers')"
    >
    </users-rectangle>
    <users-rectangle
      :being-fetched="fetchingRecommendations"
      :recommendations="recommendations"
      type="worst"
      :title="$i18n.t('message.profile.notRecommendedReviewers')"
    >
    </users-rectangle>
  </div>
</template>

<script>
import { mapState } from 'vuex';

import UsersRectangle from './users-rectangle'

export default {
  components: {
    UsersRectangle,
  },
  computed: mapState({
    recommendations: state => state.profile.recommendations,
    fetchingRecommendations: state => state.profile.fetchingRecommendations,
  }),
};
</script>
