<template>
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