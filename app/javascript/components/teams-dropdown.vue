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
import { COMPUTE_SCORES } from '../store/action-types';

export default {
  props: {
    teams: Array,
    githubLogin: String,
  },
  data() {
    return {
      dropdownTitle: this.$t('message.profile.teamsDropdownTitle'),
      noTeamsMessage: this.$t('message.profile.noTeams'),
    };
  },
  mounted() {
    const selectedTeam = this.teams[this.defaultTeamIndex];
    if (selectedTeam) {
      this.dispatchComputeScore(selectedTeam);
    }
  },
  computed: {
    defaultTeamIndex() {
      if (!localStorage.mapUserToDefaultTeam) {
        return 0;
      }
      const mapUserToDefaultTeam = JSON.parse(localStorage.mapUserToDefaultTeam);
      if (!mapUserToDefaultTeam.hasOwnProperty(this.githubLogin)) {
        return 0;
      }
      const teamId = mapUserToDefaultTeam[this.githubLogin];
      const index = this.teams.findIndex(team => team.id === teamId);
      if (index >= 0) {
        return index;
      }

      return 0;
    },
  },
  methods: {
    onItemClicked({ item }) {
      this.dispatchComputeScore(item);
      this.makeTeamDefault(item);
    },

    dispatchComputeScore(team) {
      this.$store.dispatch(COMPUTE_SCORES, {
        teamId: team.id,
        organizationId: team.organization_id,
        githubUserLogin: this.githubLogin,
      });
    },

    makeTeamDefault(team) {
      const mapUserToDefaultTeam =
        localStorage.mapUserToDefaultTeam ?
          JSON.parse(localStorage.mapUserToDefaultTeam) :
          {};
      mapUserToDefaultTeam[this.githubLogin] = team.id;
      localStorage.mapUserToDefaultTeam = JSON.stringify(mapUserToDefaultTeam);
    },
  },
  components: {
    ClickableDropdown,
  },
};
</script>
