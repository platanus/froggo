<template>
  <slide>
    <div class="pd-card__container">
      <public-dashboard-profile 
        v-for="(user, index) in githubUsers"
        :key="index"
        :githubLogin="user.githubLogin"
        :imageUrl="user.imageUrl"
        :organizationId="organizationId"
      >
      </public-dashboard-profile>
    </div>
  </slide>
</template>

<script>
import { Slide } from 'vue-carousel';

import PublicDashboardProfile from './profile';

export default {
  components: {
    Slide,
    PublicDashboardProfile,
  },
  props: {
    githubUsers: Array,
    organizationId: String,
  },
}
</script>
