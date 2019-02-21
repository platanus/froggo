<template>
  <carousel
    :per-page="1"
    :loop="true"
    :autoplay="true"
    :paginationEnabled="false"
    :autoplayTimeout="5000"
    :autoplayHoverPause="false"
    tagName="public-dashboard-slide"
    @pageChange="onPageChange"
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
import { COMPUTE_SCORES } from '../../store/action-types';

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
  mounted() {
    if (this.chunkedUsers.length > 0) {
      this.dispatchComputeScoreForChunk(0);
    }
  },
  methods: {
    onPageChange(chunkIndex) {
      this.dispatchComputeScoreForChunk(chunkIndex);
    },
    dispatchComputeScoreForChunk(chunkIndex) {
      this.chunkedUsers[chunkIndex].forEach(user => {
        this.$store.dispatch(
          COMPUTE_SCORES, {
            githubUserLogin: user.githubLogin,
            organizationId: this.organizationId,
          }
        );
      });
    },
  },
};
</script>
