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
        <h3>{{ $i18n.t('message.metrics.noPullRequestInformation') }}</h3>
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
import MetricsHandler from './profile/metrics-handler.vue';
import {
  COMPUTE_TEAM_PR_INFORMATION,
} from '../store/action-types';

export default {
  beforeMount() {
    this.$store.dispatch(COMPUTE_TEAM_PR_INFORMATION, {
      githubUsers: this.froggoTeamMembers,
    });
  },
  components: {
    MetricsHandler,
  },
  props: {
    froggoTeamMembers: {
      type: Array,
      required: true,
    },
  },
  computed: mapState({
    pullRequestsInformation: state => state.froggoTeam.pullRequestInformation,
    beingFetched: state => state.froggoTeam.fetchingPullRequestInformation,
  }),
};
</script>
