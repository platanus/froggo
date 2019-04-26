<template>
  <div
    class="profile-recommendations-users"
    <div class="profile-recommendations-users__title">
      {{ title }}
    </div>
    <div class="profile-recommendations-users__users">
      <div v-if="beingFetched" class="loading-icon"></div>
      <div
        v-else
        class="profile-recommendations-users__user"
        v-for="user in recommendations[type]"
        :key="user.id">
        <img class="profile-recommendations-users__picture" :src="user.avatar_url" />
        <div class="profile-recommendations-users__username">
          {{ user.login }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: String,
    recommendations: Object,
    type: String,
    beingFetched: Boolean,
  },
};
</script>
