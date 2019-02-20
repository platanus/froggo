<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    :default-index="defaultTeamIndex"
    @item-clicked="onItemClicked"
  >
  </clickable-dropdown>
</template>

<script>
import ClickableDropdown from './clickable-dropdown';
import { COMPUTE_SCORE } from '../store/action-types';

export default {
  props: {
    teams: Array,
    githubLogin: String,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.teamsDropdownTitle'),
      noTeamsMessage: this.$t('message.profile.noTeams'),
      defaultTeamIndex: 0,
    };
  },
  created() {
    const selectedTeam = this.teams[this.defaultTeamIndex];
    if (selectedTeam) {
      this.dispatchComputeScore(selectedTeam);
    }
  },
  methods: {
    onItemClicked({ item }) {
      this.dispatchComputeScore(item);
    },

    dispatchComputeScore(team) {
      this.$store.dispatch(COMPUTE_SCORE, {
        teamId: team.id,
        organizationId: team.organization_id,
        githubUserLogin: this.githubLogin,
        weeksAgo: 1,
      });
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
