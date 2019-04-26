<template>
  <div class="profile-recommendations">
    <users-rectangle
      :being-fetched="fetchingRecommendations"
      :recommendations="recommendations"
      type="best"
      title="Te recomendamos mandar tu próximo PR a una de estas personas"
    >
    </users-rectangle>
    <users-rectangle
      :being-fetched="fetchingRecommendations"
      :recommendations="recommendations"
      type="worst"
      title="Evita mandarle otro PR a una de estas personas"
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
