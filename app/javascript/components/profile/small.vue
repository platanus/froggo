<template>
  <a :href="linkToProfile" class="profile__summary">
    <div class="profile__avatar profile__summary--small">
      <img :src="avatarUrl" />
    </div>
    <div class="profile__text profile__summary--text">
      {{ githubLogin }}
    </div>
  </a>
</template>

<script>
export default {
  props: {
    avatarUrl: String,
    githubLogin: String,
    linkToProfile: {
      type: String,
      default: '#',
    },
  },
};
</script>
