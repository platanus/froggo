<template>
  <div
    class="profile-recommendations-users"
    :class="`profile-recommendations-users--${type}`">
    <div class="profile-recommendations-users__title">
      {{ title }}
    </div>
    <div class="profile-recommendations-users__users">
      <div v-if="beingFetched || !recommendations" class="loading-icon"></div>
      <a
        v-else
        class="profile-recommendations-users__user"
        v-for="user in recommendations[type]"
        :key="user.id"
        :href="`/users/${user.id}`">
        <img class="profile-recommendations-users__picture" :src="user.avatar_url" />
        <div class="profile-recommendations-users__username">
          {{ user.login }}
        </div>
        <div :class="`profile-recommendations-users__color-badge profile-recommendations-users__color-badge--${colorFromScore(user.score)}`"></div>
      </a>
    </div>
  </div>
</template>

<script>
import colorFromScore from '../../helpers/color-from-score.js'

export default {
  props: {
    title: String,
    recommendations: Object,
    type: String,
    beingFetched: Boolean,
  },
  methods: {
    colorFromScore: colorFromScore
  }
};
</script>
