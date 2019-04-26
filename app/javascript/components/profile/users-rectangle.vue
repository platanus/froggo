<template>
  <div
    class="profile-recommendations-users"
    <div class="profile-recommendations-users__title">
      {{ title }}
    </div>
        <small-profile
          v-else
          v-for="user in recommendations[type]"
          :key="user.id"
          :github-login="user.login"
          :link-to-profile="user.html_url"
          :avatar-url="user.avatar_url"
        >
        </small-profile>
    <div class="profile-recommendations-users__users">
      <div v-if="beingFetched" class="loading-icon"></div>
      </div>
    </div>
  </div>
</template>

<script>
import SmallProfile from './small.vue';

export default {
  props: {
    title: String,
    recommendations: Object,
    type: String,
    beingFetched: Boolean,
  },
  components: {
    SmallProfile,
  },
};
</script>