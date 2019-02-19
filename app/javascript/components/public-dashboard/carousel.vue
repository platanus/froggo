<template>
  <carousel 
    :per-page="1" 
    :loop="true"
    :autoplay="true"
    :paginationEnabled="false"
    :autoplayTimeout="10000"
    tagName="public-dashboard-slide"
  >
    <public-dashboard-slide 
      v-for="(githubUsers, index) in chunkedUsers"
      :key="index"
      :organization-id="organizationId"
      :github-users="githubUsers"
    >
    </public-dashboard-slide>
  </carousel>
</template>

<script>
import { Carousel } from 'vue-carousel';
import chunk from 'lodash.chunk';

import PublicDashboardSlide from './slide';

const USERS_PER_SLIDE = 4;

export default {
  components: {
    Carousel,
    PublicDashboardSlide,
  },
  props: {
    organizationId: String,
    githubUsers: Array,
  },
  data() {
    return {
      chunkedUsers: chunk(this.githubUsers, USERS_PER_SLIDE),
    };
  },
};
</script>
