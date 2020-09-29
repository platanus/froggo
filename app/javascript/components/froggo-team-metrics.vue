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
      <div class="team-metrics">
        <h2>Metricas del equipo</h2>
        <div class="profile-teams">
          <clickable-dropdown
            :body-title="$i18n.t('message.profile.timespanDropdownTitle')"
            :items="monthsOptions"
            :default-index="1"
            @item-clicked="onItemClick"
          />
        </div>
      </div>
      <metrics-handler
        :pull-request-information="pullRequestsInformation"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import MetricsHandler from './profile/metrics-handler.vue';
import ClickableDropdown from './clickable-dropdown';
import {
  COMPUTE_TEAM_PR_INFORMATION,
} from '../store/action-types';

export default {
  beforeMount() {
    this.$store.dispatch(COMPUTE_TEAM_PR_INFORMATION, {
      githubUsers: this.froggoTeamMembers,
      monthLimit: 3,
    });
  },
  components: {
    MetricsHandler,
    ClickableDropdown,
  },
  props: {
    froggoTeamMembers: {
      type: Array,
      required: true,
    },
    monthsOptions: {
      type: Array,
      default() {
        return [];
      },
    },
  },
  methods: {
    onItemClick({ item }) {
      this.selectTimespan(item.limit);
    },
    selectTimespan(limit) {
      this.$store.dispatch(COMPUTE_TEAM_PR_INFORMATION, {
        githubUsers: this.froggoTeamMembers,
        monthLimit: limit,
      });
    },
  },
  computed: mapState({
    pullRequestsInformation: state => state.froggoTeam.pullRequestInformation,
    beingFetched: state => state.froggoTeam.fetchingPullRequestInformation,
  }),
};
</script>
