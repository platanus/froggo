<template>
  <div>
    <div
      v-if="beingFetched"
      class="loading-icon"
    />
    <div
      v-else-if="Object.keys(pullRequestsInformation).length === 0"
    >
      <div class="profile-stat">
        <h3>No hay información de pull requests para obtener métricas</h3>
      </div>
    </div>
    <div
      v-else
    >
      <Metrics-handler
        :pull-request-information="pullRequestsInformation"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import MetricsHandler from './metrics-handler.vue';

export default {
  computed: mapState({
    pullRequestsInformation: state => state.profile.pullRequestInformation,
    beingFetched: state => state.profile.fetchingPullRequestInformation,
  }),
  components: {
    MetricsHandler,
  },
};
</script>
