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
    userId: String,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.teamsDropdownTitle'),
      noTeamsMessage: this.$t('message.profile.noTeams'),
      defaultTeamIndex: 0,
    };
  },
  created() {
    this.dispatchComputeScore(this.teams[this.defaultTeamIndex]);
  },
  methods: {
    onItemClicked({ item }) {
      this.dispatchComputeScore(item);
    },

    dispatchComputeScore(team) {
      this.$store.dispatch(COMPUTE_SCORE, {
        teamId: team.id,
        organizationId: team.organization_id,
        userId: parseInt(this.userId, 10),
        weeksAgo: 36,
      });
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
