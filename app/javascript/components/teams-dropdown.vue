<template>
  <clickable-dropdown
    :body-title="dropdownTitle"
    :no-items-message="noTeamsMessage"
    :items="teams"
    @item-clicked="onItemClicked"
    @created="onDropdownCreated"
  >
  </clickable-dropdown>
</template>

<script>
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
    };
  },
  methods: {
    onItemClicked({ item }) {
      this.dispatchComputeScore(item);
    },

    onDropdownCreated({ selected: { item } }) {
      this.dispatchComputeScore(item);
    },

    dispatchComputeScore(team) {
      this.$store.dispatch(COMPUTE_SCORE, {
        teamId: team.id,
        organizationId: team.organization_id,
        userId: parseInt(this.userId, 10),
        weeksAgo: 1,
      });
    },
  },
};
</script>
