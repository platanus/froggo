<template>
  <div class="profile__column">
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

import SmallProfile from './small.vue';

const UsersRectangle = {
  props: {
    title: String,
    recommendations: Object,
    type: String,
    beingFetched: Boolean,
  },
  template: `
    <div class="profile__column">
      <div class="profile__row profile__title">
        {{ title }}
      </div>
      <div class="profile__row">
        <div class="profile__rectangle
                    profile__rectangle--small
                    profile__rectangle--padded">
          <div v-if="beingFetched" class="loading-icon"></div>
          <small-profile
            v-else
            v-for="user in recommendations[type]"
            :key="user.id"
            :github-login="user.login"
            :link-to-profile="user.html_url"
            :avatar-url="user.avatar_url"
          >
          </small-profile>
        </div>
      </div>
    </div>
  `,
  components: {
    SmallProfile,
  },
};

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
